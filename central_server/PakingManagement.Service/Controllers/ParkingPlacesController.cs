using AutoMapper;
using Makers.SmartParking.DataAccess.Repositories;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.Domain.Enums;
using Makers.SmartParking.PakingManagement.Service.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Makers.SmartParking.PakingManagement.Service.Controllers
{
    public class ParkingPlacesController : ApiController
    {
        #region Dependencies

        private IParkingsRepository parkingsRepository;
        private IMappingEngine mapper;

        #endregion

        public ParkingPlacesController(IParkingsRepository parkingsRepository, IMappingEngine mapper)
        {
            this.parkingsRepository = parkingsRepository;
            this.mapper = mapper;
        }

        public ParkingPlacesController()
            :this(new ParkingsRepository(), Mapper.Engine)
        {
            
        }
        
        [HttpGet]
        [Route("api/parkings/{parkingId:int}/places/{parkingPlaceId:int}/status")]
        public IHttpActionResult UpdateStatus(int parkingId, int parkingPlaceId, [FromUri] ParkingPlaceStatus status)
        {
            try
            {
                // Select parking place
                var parkingPlace = parkingsRepository.GetParkingPlace(parkingPlaceId, p => p.CurrentStatus);
                if (parkingPlace == null || parkingPlace.ParkingId != parkingId)
                    return NotFound();

                if (parkingPlace.CurrentStatus == null || parkingPlace.CurrentStatus.Status != status)
                {
                    var newStatus = new ParkingPlaceStatusChange
                    {
                        CreatedAt = DateTime.Now,
                        Status = status,
                        ParkingPlaceId = parkingPlace.Id
                    };
                    parkingsRepository.AddParkingPlaceStatusChange(newStatus);

                    // Update currnet status
                    parkingsRepository.UpdateParkingPlaceCurrentStatus(parkingPlace.Id, newStatus.Id);
                }

                return Ok();
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        //[HttpGet]
        //[Route("api/expired-parking-places")]
        //public IHttpActionResult GetExpiredParkingPlaces()
        //{
        //    return null;
        //}

        [Route("api/parkings/{parkingId:int}/places/by-code/{parkingPlaceCode}")]
        public IHttpActionResult Get(int parkingId, string parkingPlaceCode)
        {
            try
            {
                var parkingPlace = parkingsRepository.GetPlaceByCode(parkingId, parkingPlaceCode, o => o.CurrentStatus, o => o.Parking, o => o.Payments, o=> o.StatusChanges);
                if (parkingPlace == null)
                    return NotFound();
                
                var model = mapper.Map<ParkingPlaceModel>(parkingPlace);
                model.Parking = mapper.Map<ParkingModel>(parkingPlace.Parking);
                model.Parking.ParkingPlaces = null;

                if (parkingPlace.Payments!= null && parkingPlace.Payments.Count() > 0)
                    model.ExpiresAt = parkingPlace.Payments.Max(o => o.CreatedAt + o.Duration);

                return Ok(model);
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, e.Message);
            }
        }
    }
}
