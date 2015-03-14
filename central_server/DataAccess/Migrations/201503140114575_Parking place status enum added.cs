namespace Makers.SmartParking.DataAccess.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Parkingplacestatusenumadded : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.ParkingPlaceStatusChanges", "Status", c => c.Int(nullable: false));
            DropColumn("dbo.ParkingPlaceStatusChanges", "IsOccupied");
        }
        
        public override void Down()
        {
            AddColumn("dbo.ParkingPlaceStatusChanges", "IsOccupied", c => c.Boolean(nullable: false));
            DropColumn("dbo.ParkingPlaceStatusChanges", "Status");
        }
    }
}
