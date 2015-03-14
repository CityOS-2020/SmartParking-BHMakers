using Makers.SmartParking.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    public class ParkingPlaceStatusChange
    {
        public int Id { get; set; }

        public int ParkingPlaceId { get; set; }
        public ParkingPlace ParkingPlace { get; set; }

        public ParkingPlaceStatus Status { get; set; }

        public DateTime CreatedAt { get; set; }
    }
}
