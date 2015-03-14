using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    public class ParkingPlace
    {
        public int Id { get; set; }

        public string Code { get; set; }

        public int ParkingId { get; set; }
        public Parking Parking { get; set; }

        public int? CurrentStatusId { get; set; }
        public ParkingPlaceStatusChange CurrentStatus { get; set; }

        public IList<ParkingPlaceStatusChange> StatusChanges { get; set; }

        public IList<Payment> Payments { get; set; }
    }
}
