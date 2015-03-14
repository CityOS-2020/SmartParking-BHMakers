using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models
{
    public class ExpiredParkingPlace
    {
        public ParkingPlaceModel ParkingPlace { get; set; }

        public DateTime Expired { get; set; }
    }
}