using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models
{
    public class DoPaymentModel
    {
        [Required(ErrorMessage="Parking ID is required.")]
        public int ParkingId { get; set; }

        [Required(ErrorMessage="Parking code is required.")]
        public string ParkingPlaceCode { get; set; }

        [Required(ErrorMessage="Duration is required.")]
        public TimeSpan Duration { get; set; }
    }
}