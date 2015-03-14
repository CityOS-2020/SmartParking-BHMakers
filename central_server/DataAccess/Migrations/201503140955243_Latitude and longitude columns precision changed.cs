namespace Makers.SmartParking.DataAccess.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Latitudeandlongitudecolumnsprecisionchanged : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Parkings", "GpsPosition_Latitude", c => c.Decimal(nullable: false, precision: 15, scale: 12));
            AlterColumn("dbo.Parkings", "GpsPosition_Longitude", c => c.Decimal(nullable: false, precision: 15, scale: 12));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Parkings", "GpsPosition_Longitude", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Parkings", "GpsPosition_Latitude", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
    }
}
