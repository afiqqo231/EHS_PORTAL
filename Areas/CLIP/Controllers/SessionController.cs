using System.Web.Mvc;
using EHS_PORTAL.Areas.CLIP.Filters;

namespace EHS_PORTAL.Areas.CLIP.Controllers
{
    [ClipAuthorize]
    public class SessionController : Controller
    {
        /// <summary>
        /// Endpoint to keep the user's session alive
        /// </summary>
        /// <returns>JSON result indicating success</returns>
        [HttpPost]
        public JsonResult KeepAlive()
        {
            // The mere act of hitting this authenticated endpoint extends the session
            return Json(new { success = true, message = "Session extended" });
        }
    }
} 