using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.ComputedBusinessObjects
{
    public class ExpiredParkingPlace
    {
        public int ParkingPlaceId { get; set; }
        public ParkingPlace ParkingPlace { get; set; }

        public DateTime? ExpiredAt { get; set; }
    }
}
