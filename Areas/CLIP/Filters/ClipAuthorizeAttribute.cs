using System;
using System.Web.Mvc;

namespace EHS_PORTAL.Areas.CLIP.Filters
{
    // Custom authorize for CLIP. Returns 302 redirect instead of 401,
    // preventing FormsAuthenticationModule from hijacking the response
    // and redirecting to the FETS login page.
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false)]
    public class ClipAuthorizeAttribute : AuthorizeAttribute
    {
        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            string returnUrl = filterContext.HttpContext.Request.Url?.PathAndQuery;
            string loginUrl = "/CLIP/Account/Login";

            if (!string.IsNullOrEmpty(returnUrl))
                loginUrl += "?ReturnUrl=" + Uri.EscapeDataString(returnUrl);

            filterContext.Result = new RedirectResult(loginUrl);
        }
    }
}
