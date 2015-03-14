using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    [ComplexType]
    public class GpsCoordinate
    {
        public decimal Latitude { get; set; }

        public decimal Longitude { get; set; }
    }
}
