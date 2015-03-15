using Makers.SmartParking.DataAccess.Infrastructure;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.Domain.ComputedBusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.DataAccess.Repositories
{
    public class ParkingsRepository : RepositoryBase, IParkingsRepository
    {
        public ParkingPlace GetParkingPlace(int parkingPlaceId, params Expression<Func<ParkingPlace, object>>[] includes)
        {
            using (var context = GetContext())
            {
                IQueryable<ParkingPlace> query = context.ParkingPlaces;
                query = ApplyInclude(query, includes);

                var parkingPlace = query.SingleOrDefault(p => p.Id == parkingPlaceId);
                return parkingPlace;
            }
        }

        public void AddParkingPlaceStatusChange(ParkingPlaceStatusChange statusChange)
        {
            using (var context = GetContext())
            {
                context.ParkingPlaceStatusChanges.Add(statusChange);
                context.SaveChanges();
            }
        }

        public void UpdateParkingPlaceCurrentStatus(int parkingPlaceId, int newStatusChangeId)
        {
            using (var context = GetContext())
            {
                var parkingPlace = context.ParkingPlaces.Find(parkingPlaceId);
                if (parkingPlace == null)
                    throw new Exception("Parking place doesn't exist.");

                parkingPlace.CurrentStatusId = newStatusChangeId;
                context.SaveChanges();
            }
        }


        public Parking GetParking(int parkingId, params Expression<Func<Parking, object>>[] includes)
        {
            using (var context = GetContext())
            {
                IQueryable<Parking> query = context.Parkings;
                query = ApplyInclude(query, includes);

                var parking = query.SingleOrDefault(o => o.Id == parkingId);
                return parking;
            }
        }

        public IList<Parking> GetParkings(params Expression<Func<Parking, object>>[] includes)
        {
            using (var context = GetContext())
            {
                IQueryable<Parking> query = context.Parkings;
                query = ApplyInclude(query, includes);

                var parkings = query.ToList();
                return parkings;
            }
        }

        public ParkingPlace GetPlaceByCode(int parkingId, string parkingPlaceCode, params Expression<Func<ParkingPlace, object>>[] includes)
        {
            using (var context = GetContext())
            {
                var query = ApplyInclude(context.ParkingPlaces, includes);
                var parkingPlace = query.SingleOrDefault(o => o.ParkingId == parkingId && o.Code == parkingPlaceCode);
                return parkingPlace;
            }
        }

        public IList<ExpiredParkingPlace> GetExpiredAndOccupiedParkingPlaces()
        {
            using (var context = GetContext())
            {
                var expiredPlaces = context.Database.SqlQuery<ExpiredParkingPlace>(
                    @"SELECT
	                    *
                    FROM (
	                    SELECT pl.Id AS ParkingPlaceId,
		                    MAX(CAST(py.Duration AS DATETIME) + py.CreatedAt) AS ExpiredAt
	                    FROM ParkingPlaces pl
	                    LEFT JOIN Payments py ON py.ParkingPlaceId=pl.Id
	                    LEFT JOIN ParkingPlaceStatusChanges ch ON ch.Id=pl.CurrentStatusId
	                    WHERE ch.Status = 2
	                    GROUP BY pl.Id) AS Results
                    WHERE ExpiredAt IS NULL OR ExpiredAt < GETDATE()").ToList();

                // Load parking places
                var parkingPlacesIds = expiredPlaces.Select(o => o.ParkingPlaceId).ToList();
                var parkingPlaces = context.ParkingPlaces.Where(o => parkingPlacesIds.Contains(o.Id)).ToDictionary(o => o.Id, o => o);
                expiredPlaces.ForEach(p => p.ParkingPlace = parkingPlaces[p.ParkingPlaceId]);

                return expiredPlaces;
            }
        }
    }
}
