using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models
{
    public class ParkingModel
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public GpsCoordinateModel GpsCoordinate { get; set; }

        public IList<ParkingPlaceModel> ParkingPlaces { get; set; }

        public int TotalPlaces { get; set; }

        public int FreePlaces { get; set; }

        public int BlockedSensors { get; set; }

        public int ExpiredButOccupiedPlaces { get; set; }
    }
}