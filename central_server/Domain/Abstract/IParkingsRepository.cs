using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.Domain.ComputedBusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.Abstract
{
    public interface IParkingsRepository
    {
        ParkingPlace GetParkingPlace(int parkingPlaceId, params Expression<Func<ParkingPlace, object>>[] includes);

        void AddParkingPlaceStatusChange(ParkingPlaceStatusChange statusChange);

        void UpdateParkingPlaceCurrentStatus(int parkingPlaceId, int newStatusChangeId);

        Parking GetParking(int parkingId, params Expression<Func<Parking, object>>[] includes);

        IList<Parking> GetParkings(params Expression<Func<Parking, object>>[] includes);

        ParkingPlace GetPlaceByCode(int parkingId, string parkingPlaceCode, params Expression<Func<ParkingPlace, object>>[] includes);

        IList<ExpiredParkingPlace> GetExpiredAndOccupiedParkingPlaces();
    }
}
