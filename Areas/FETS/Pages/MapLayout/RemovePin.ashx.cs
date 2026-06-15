using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace EHS_PORTAL.Areas.FETS.Pages.MapLayout
{
    /// <summary>
    /// Summary description for RemovePin
    /// </summary>
    public class RemovePin : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string feId = context.Request.Form["feId"];
            if (string.IsNullOrEmpty(feId)) { context.Response.Write("error"); return; }

            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE FETS.FireExtinguishers SET PinX = NULL, PinY = NULL WHERE FEID = @feId", conn))
                {
                    cmd.Parameters.AddWithValue("@feId", feId);
                    cmd.ExecuteNonQuery();
                }
            }
            context.Response.Write("ok");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}