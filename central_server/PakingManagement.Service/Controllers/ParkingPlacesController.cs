using Makers.SmartParking.DataAccess.Repositories;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.Domain.Enums;
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
        
        #endregion

        public ParkingPlacesController(IParkingsRepository parkingsRepository)
        {
            this.parkingsRepository = parkingsRepository;
        }

        public ParkingPlacesController()
            :this(new ParkingsRepository())
        {
            
        }
        
        [HttpGet]
        [Route("api/parkings/{parkingId:int}/places/{parkingPlaceId:int}/")]
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

        [HttpGet]
        [Route("api/expired-parking-places")]
        public IHttpActionResult GetExpiredParkingPlaces()
        {
            return null;
        }
    }
}
