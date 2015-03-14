using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    public class Payment
    {
        public int Id { get; set; }

        public int? UserId { get; set; }
        public User User { get; set; }

        public int ParkingPlaceId { get; set; }
        public ParkingPlace ParkingPlace { get; set; }

        public TimeSpan Duration { get; set; }

        public decimal Price { get; set; }

        public DateTime CreatedAt { get; set; }
    }
}
