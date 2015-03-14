using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    public class Parking
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public GpsCoordinate GpsPosition { get; set; }

        public IList<ParkingPlace> ParkingPlaces { get; set; }
    }
}
