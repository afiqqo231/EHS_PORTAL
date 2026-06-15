namespace EHS_PORTAL.Areas.CLIP.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIsActiveToUser : DbMigration
    {
        public override void Up()
        {
            AddColumn("CLIP.AspNetUsers", "IsActive", c => c.Boolean(nullable: false, defaultValue: true));
        }

        public override void Down()
        {
            DropColumn("CLIP.AspNetUsers", "IsActive");
        }
    }
}
