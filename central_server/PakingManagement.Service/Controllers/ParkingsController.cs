using AutoMapper;
using Makers.SmartParking.DataAccess.Repositories;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.PakingManagement.Service.Models;
using Makers.SmartParking.ServicesInfrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Makers.SmartParking.PakingManagement.Service.Controllers
{
    public class ParkingsController : ApiController
    {
        #region Dependencies

        private IParkingsRepository parkingsRepository;
        private IMappingEngine mapper;

        #endregion

        public ParkingsController(IParkingsRepository parkingsRepository, IMappingEngine mapper)
        {
            this.parkingsRepository = parkingsRepository;
            this.mapper = mapper;
        }

        public ParkingsController()
            :this(new ParkingsRepository(), Mapper.Engine)
        {
            
        }

        public IHttpActionResult Get()
        {
            try
            {
                var parkings = parkingsRepository.GetParkings(p => p.ParkingPlaces.Select(pl => pl.CurrentStatus));
                var models = mapper.Map<IList<ParkingModel>>(parkings);

                // Expired places
                var expiredPlaces = parkingsRepository.GetExpiredAndOccupiedParkingPlaces();

                // Remove parking places
                foreach (var parking in models)
                {
                    parking.ParkingPlaces = null;
                    parking.ExpiredButOccupiedPlaces = expiredPlaces.Count(o => o.ParkingPlace.ParkingId == parking.Id);
                }

                return Ok(models);
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, new ErrorModel(e.Message));
            }
        }

        [Route("api/parkings/{parkingId:int}")]
        public IHttpActionResult Get(int parkingId)
        {
            try
            {
                var parking = parkingsRepository.GetParking(parkingId, p => p.ParkingPlaces.Select(pl => pl.CurrentStatus));
                if (parking == null)
                    return NotFound();

                var model = mapper.Map<ParkingModel>(parking);

                // Check for expired status
                var expiredParkingPlaces = parkingsRepository.GetExpiredAndOccupiedParkingPlaces().ToDictionary(o => o.ParkingPlaceId, o => o);
                foreach (var place in model.ParkingPlaces)
                {
                    if (expiredParkingPlaces.ContainsKey(place.Id))
                    {
                        place.Status = ParkingPlaceStatusModel.Expired;
                    }
                }

                // Total expired
                model.ExpiredButOccupiedPlaces = model.ParkingPlaces.Count(o => o.Status == ParkingPlaceStatusModel.Expired);

                return Ok(model);
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, new ErrorModel(e.Message));
            }
        }
    }
}
