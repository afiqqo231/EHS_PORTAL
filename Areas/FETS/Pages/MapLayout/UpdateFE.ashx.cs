using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace EHS_PORTAL.Areas.FETS.Pages.MapLayout
{
    public class UpdateFE : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            if (!context.User.Identity.IsAuthenticated)
            {
                context.Response.StatusCode = 401;
                context.Response.Write("Unauthorized");
                return;
            }

            string feIdStr = context.Request.Form["feId"];
            string serial = context.Request.Form["serial"];
            string location = context.Request.Form["location"];
            string typeIdStr = context.Request.Form["typeId"];
            string expiry = context.Request.Form["expiry"];
            string statusIdStr = context.Request.Form["statusId"];

            if (!int.TryParse(feIdStr, out int feId) || !int.TryParse(typeIdStr, out int typeId) || !int.TryParse(statusIdStr, out int statusId) || string.IsNullOrWhiteSpace(serial) || string.IsNullOrWhiteSpace(location))
            {
                context.Response.StatusCode = 400;
                context.Response.Write("Invalid parameters");
                return;
            }

            DateTime? expiryDate = null;
            if (DateTime.TryParse(expiry, out DateTime parsed))
            {
                expiryDate = parsed;
            }

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string sql = @"UPDATE FETS.FireExtinguishers SET SerialNumber = @Serial, Location = @Location, TypeID = @TypeID, DateExpired = @Expiry, StatusID = @StatusID WHERE FEID = @FEID";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Serial", serial);
                        cmd.Parameters.AddWithValue("@Location", location);
                        cmd.Parameters.AddWithValue("@TypeID",   typeId);
                        cmd.Parameters.AddWithValue("@Expiry",   (object)expiryDate ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@StatusID", statusId);
                        cmd.Parameters.AddWithValue("@FEID",     feId);

                        int rows = cmd.ExecuteNonQuery();
                        if (rows == 0)
                        {
                            context.Response.StatusCode = 404;
                            context.Response.Write("FE not found");
                            return;
                        }
                    }
                }
                context.Response.Write("ok");
            }
            catch (Exception ex)
                {
                    context.Response.StatusCode = 500;
                    context.Response.Write("Error: " + ex.Message);
                }
        }
        public bool IsReusable => false;
    }
}