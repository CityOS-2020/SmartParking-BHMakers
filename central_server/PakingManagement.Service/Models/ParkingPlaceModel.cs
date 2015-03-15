using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models
{
    public class ParkingPlaceModel
    {
        public int Id { get; set; }

        public string Code { get; set; }

        public ParkingPlaceStatusModel Status { get; set; }

        public int ParkingId { get; set; }
        public ParkingModel Parking { get; set; }

        public DateTime? ExpiresAt { get; set; }
    }
}