namespace Makers.SmartParking.DataAccess.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CurrentStatusIdfiledfixedinParkingPlaceStatusChangetable : DbMigration
    {
        public override void Up()
        {
            RenameColumn(table: "dbo.ParkingPlaces", name: "CurrentStatus_Id", newName: "CurrentStatusId");
            RenameIndex(table: "dbo.ParkingPlaces", name: "IX_CurrentStatus_Id", newName: "IX_CurrentStatusId");
            DropColumn("dbo.ParkingPlaces", "CurrentSatus");
        }
        
        public override void Down()
        {
            AddColumn("dbo.ParkingPlaces", "CurrentSatus", c => c.Int());
            RenameIndex(table: "dbo.ParkingPlaces", name: "IX_CurrentStatusId", newName: "IX_CurrentStatus_Id");
            RenameColumn(table: "dbo.ParkingPlaces", name: "CurrentStatusId", newName: "CurrentStatus_Id");
        }
    }
}
