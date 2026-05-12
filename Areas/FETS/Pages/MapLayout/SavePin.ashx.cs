using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace EHS_PORTAL.Areas.FETS.Pages.MapLayout
{
    /// <summary>
    /// Handler that saves the pin coordinate for each FE in the FETS.FireExtinguishers.
    /// </summary>
    public class SavePin : IHttpHandler
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
            string pinXStr = context.Request.Form["pinX"];
            string pinYStr = context.Request.Form["pinY"];

            if (!int.TryParse(feIdStr, out int feId) || !double.TryParse(pinXStr, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out double pinX) || !double.TryParse(pinYStr, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out double pinY))
            {
                context.Response.StatusCode = 400;
                context.Response.Write("Invalid parameters");
                return;
            }

            pinX = Math.Max(0.0, Math.Min(1.0, pinX));
            pinY = Math.Max(0.0, Math.Min(1.0, pinY));

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string sql = @"
                        UPDATE FETS.FireExtinguishers SET PinX = @PinX, PinY = @PinY
                        WHERE FEID = @FEID
                        ";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@PinX", pinX);
                            cmd.Parameters.AddWithValue("@PinY", pinY);
                            cmd.Parameters.AddWithValue("@FEID", feId);

                            int rowsAffected = cmd.ExecuteNonQuery();
                            if (rowsAffected == 0)
                            {
                                context.Response.StatusCode = 404;
                                context.Response.Write("Fire extinguisher not found");
                            }
                        }
                }
                context.Response.Write("ok");
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("Error :" + ex.Message);
            }

        }

        public bool IsReusable => false;
    }
}