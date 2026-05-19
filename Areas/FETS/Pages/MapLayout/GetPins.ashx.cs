using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace EHS_PORTAL.Areas.FETS.Pages.MapLayout
{
    public class GetPins :IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            if (!context.User.Identity.IsAuthenticated)
            {
                context.Response.StatusCode = 401;
                context.Response.Write("[]");
                return;
            }

            string plantIdStr = context.Request.QueryString["PlantID"];
            string levelIdStr = context.Request.QueryString["LevelID"];

            if (!int.TryParse(plantIdStr, out int plantId) || !int.TryParse(levelIdStr, out int levelId))
            {
                context.Response.StatusCode = 400;
                context.Response.Write("[]");
                return;
            }

            var pins = new List<object>();

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string sql = @"
                        SELECT fe.FEID, fe.SerialNumber, fe.Location, t.TypeName, s.StatusName, fe.PinX, fe.PinY, fe.DateExpired
                        FROM FETS.FireExtinguishers fe
                        INNER JOIN FETS.FireExtinguisherTypes t ON fe.TypeID = t.TypeID
                        INNER JOIN FETS.Status s ON fe.StatusID = s.StatusID
                        WHERE fe.PlantID = @PlantID
                            AND fe.LevelID = @LevelID
                            AND fe.PinX IS NOT NULL
                            AND fe.PinY IS NOT NULL";
                            
                    using (SqlCommand cmd = new SqlCommand(sql,conn))
                    {
                        cmd.Parameters.AddWithValue("@PlantID", plantId);
                        cmd.Parameters.AddWithValue("@LevelID", levelId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                pins.Add(new
                                {
                                    feId = reader.GetInt32(0),
                                    serial = reader.GetString(1),
                                    location = reader.GetString(2),
                                    type = reader.GetString(3),
                                    status = reader.GetString(4),
                                    pinX = Convert.ToDouble(reader["PinX"]),
                                    pinY = Convert.ToDouble(reader["PinY"]),
                                    expiry = reader.IsDBNull(7) ? "" : Convert.ToDateTime(reader[7]).ToString("dd/MM/yyyy")
                                });
                            }
                        }
                    }
                }

                context.Response.Write(JsonConvert.SerializeObject(pins));
                
            }
            catch (Exception ex)
            {
                 context.Response.StatusCode = 500;
                 context.Response.Write("[]");
            }
        }

        public bool IsReusable => false;
    }
}