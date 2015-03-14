using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models
{
    public enum ParkingPlaceStatusModel
    {
        Unknown = 0,
        Free = 1,
        Occupied = 2,
        Blocked = 3,
        Expired = 4
    }
}