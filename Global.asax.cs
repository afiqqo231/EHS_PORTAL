using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Data.Entity;
using EHS_PORTAL.Areas.CLIP.Models;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using Microsoft.AspNet.Identity;
using System.Globalization;

namespace EHS_PORTAL
{
    public class MvcApplication : System.Web.HttpApplication
    {
        private static Timer _statusUpdateTimer = null;
        private static readonly TimeSpan _updateInterval = TimeSpan.FromHours(24);
        private static readonly object _lockObject = new object();
        private static bool _isUpdating = false;

        protected void Application_Start()
        {
            // Set default culture to use dd/MM/yyyy date format
            var customCulture = (CultureInfo)Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.DateTimeFormat.ShortDatePattern = "dd/MM/yyyy";
            customCulture.DateTimeFormat.DateSeparator = "/";
            Thread.CurrentThread.CurrentCulture = customCulture;
            Thread.CurrentThread.CurrentUICulture = customCulture;
            
            // Register custom model binder for DateTime
            ModelBinders.Binders.Add(typeof(DateTime), new DateTimeModelBinder());
            ModelBinders.Binders.Add(typeof(DateTime?), new DateTimeModelBinder());
            
            // Disable database migration check
            Database.SetInitializer<ApplicationDbContext>(null);

            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            
            // Seed sample plants if they don't exist
            SeedSamplePlants();
            
            // Update Certificate statuses immediately at startup
            UpdateCertificateStatuses();
            
            // Set up timer to update certificate statuses daily
            _statusUpdateTimer = new Timer(UpdateCertificateStatusesCallback, null, 
                _updateInterval, _updateInterval);
        }
        
        // Routes accessible via the public reverse proxy.
        // Everything else returns 404 when requested through the proxy host.
        private static readonly string[] _proxyAllowedPrefixes = new[]
        {
            "/cord/signing",
            "/cord/registration/register",
            "/cord/registration/lookuppic",
            "/cord/registration/searchpic",
            "/cord/registration/success",
            "/api/token/validate",
            "/api/eula/active-pdf",
            "/api/eula/submit-pdf",
        };

        private static readonly string[] _staticExtensions = new[]
        {
            ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico",
            ".svg", ".woff", ".woff2", ".ttf", ".eot", ".map", ".html"
        };

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            // Set culture for each request
            var customCulture = (CultureInfo)Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.DateTimeFormat.ShortDatePattern = "dd/MM/yyyy";
            customCulture.DateTimeFormat.DateSeparator = "/";
            Thread.CurrentThread.CurrentCulture = customCulture;
            Thread.CurrentThread.CurrentUICulture = customCulture;

            // Block admin/internal routes when accessed via the public proxy
            var publicHost = ConfigurationManager.AppSettings["Agreements.PublicHost"] ?? string.Empty;
            if (string.IsNullOrEmpty(publicHost)) return;

            var request = HttpContext.Current.Request;
            if (!string.Equals(request.Url.Host, publicHost, StringComparison.OrdinalIgnoreCase)) return;

            var path = request.Url.AbsolutePath.ToLowerInvariant();

            // Always allow static files
            var ext = Path.GetExtension(path);
            if (!string.IsNullOrEmpty(ext) && _staticExtensions.Contains(ext)) return;

            // Check against whitelist
            foreach (var prefix in _proxyAllowedPrefixes)
            {
                if (path == prefix || path.StartsWith(prefix + "/"))
                    return;
            }

            // Not in whitelist — block
            HttpContext.Current.Response.StatusCode = 404;
            HttpContext.Current.Response.End();
        }
        
        protected void Session_Start(object sender, EventArgs e)
        {
            // Initialize session
            Session["LastActivity"] = DateTime.Now;
        }
        
        protected void Session_End(object sender, EventArgs e)
        {
            // Session has ended - could log this event if desired
            try
            {
                if (HttpContext.Current != null && HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    // Log session timeout
                    using (var db = new ApplicationDbContext())
                    {
                        var logger = new Areas.CLIP.Services.ActivityLogger(db, new HttpContextWrapper(HttpContext.Current));
                        logger.LogActivity(
                            action: "SESSION_TIMEOUT",
                            description: "User session timed out due to inactivity",
                            entityName: "User",
                            entityId: HttpContext.Current.User.Identity.GetUserId()
                        );
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception but don't throw
                System.Diagnostics.Debug.WriteLine($"Error in Session_End: {ex.Message}");
            }
        }
        
        protected void Application_Error(object sender, EventArgs e)
        {
            Exception exception = Server.GetLastError();
            if (exception != null)
            {
                // Log the error to a file
                string logPath = Server.MapPath("~/App_Data/ErrorLogs");
                if (!Directory.Exists(logPath))
                {
                    Directory.CreateDirectory(logPath);
                }
                
                string logFile = Path.Combine(logPath, $"Error_{DateTime.Now:yyyyMMdd}.log");
                using (StreamWriter writer = new StreamWriter(logFile, true))
                {
                    writer.WriteLine("----------------- Error Details -----------------");
                    writer.WriteLine($"Date/Time: {DateTime.Now}");
                    writer.WriteLine($"URL: {Request.Url?.ToString() ?? "Unknown URL"}");
                    writer.WriteLine($"User IP: {Request.UserHostAddress ?? "Unknown IP"}");
                    writer.WriteLine($"User Agent: {Request.UserAgent ?? "Unknown Agent"}");
                    writer.WriteLine($"Error Message: {exception.Message}");
                    writer.WriteLine($"Stack Trace: {exception.StackTrace}");
                    
                    // Log inner exception if any
                    if (exception.InnerException != null)
                    {
                        writer.WriteLine($"Inner Exception: {exception.InnerException.Message}");
                        writer.WriteLine($"Inner Stack Trace: {exception.InnerException.StackTrace}");
                    }
                    
                    writer.WriteLine("--------------------------------------------------");
                    writer.WriteLine();
                }
                
                // Redirect to a custom error page
                // Response.Redirect("~/Error.cshtml");
                
                // Clear the error
                Server.ClearError();
            }
        }
        
        private void UpdateCertificateStatusesCallback(object state)
        {
            if (_isUpdating) return;
            
            try
            {
                lock(_lockObject)
                {
                    if (_isUpdating) return;
                    _isUpdating = true;
                    
                    UpdateCertificateStatuses();
                }
            }
            finally
            {
                _isUpdating = false;
            }
        }
        
        private void UpdateCertificateStatuses()
        {
            using (var context = new ApplicationDbContext())
            {
                var certificates = context.CertificateOfFitness.ToList();
                bool changesDetected = false;
                
                foreach (var certificate in certificates)
                {
                    string newStatus = CalculateStatus(certificate.ExpiryDate);
                    if (certificate.Status != newStatus)
                    {
                        certificate.Status = newStatus;
                        changesDetected = true;
                    }
                }
                
                if (changesDetected)
                {
                    context.SaveChanges();
                }
            }
        }
        
        private string CalculateStatus(DateTime expiryDate)
        {
            DateTime today = DateTime.Today;
            DateTime expiringSoonDate = expiryDate.AddDays(-90);

            if (today > expiryDate)
                return "Expired";
            else if (today >= expiringSoonDate)
                return "Expiring Soon";
            else
                return "Active";
        }
        
        private void SeedSamplePlants()
        {
            using (var context = new ApplicationDbContext())
            {
                if (!context.Plants.Any())
                {
                    // Sample plants
                    var plants = new List<Plant>
                    {
                        new Plant { PlantName = "Plant 1" },
                        new Plant { PlantName = "Plant 13" },
                        new Plant { PlantName = "Plant 3" },
                        new Plant { PlantName = "Plant 21" },
                        new Plant { PlantName = "Plant 34" },
                        new Plant { PlantName = "Plant 5" },
                        new Plant { PlantName = "Plant 55" }
                    };
                    
                    plants.ForEach(p => context.Plants.Add(p));
                    context.SaveChanges();
                }
            }
        }
    }
}
