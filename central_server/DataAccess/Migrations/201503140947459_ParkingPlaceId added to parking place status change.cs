namespace Makers.SmartParking.DataAccess.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ParkingPlaceIdaddedtoparkingplacestatuschange : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.ParkingPlaceStatusChanges", "ParkingPlaceId", c => c.Int(nullable: false));
            CreateIndex("dbo.ParkingPlaceStatusChanges", "ParkingPlaceId");
            AddForeignKey("dbo.ParkingPlaceStatusChanges", "ParkingPlaceId", "dbo.ParkingPlaces", "Id", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ParkingPlaceStatusChanges", "ParkingPlaceId", "dbo.ParkingPlaces");
            DropIndex("dbo.ParkingPlaceStatusChanges", new[] { "ParkingPlaceId" });
            DropColumn("dbo.ParkingPlaceStatusChanges", "ParkingPlaceId");
        }
    }
}
