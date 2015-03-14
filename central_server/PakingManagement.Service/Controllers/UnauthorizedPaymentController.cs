using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.PakingManagement.Service.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Makers.SmartParking.ServicesInfrastructure.Models;
using Microsoft.AspNet.Identity;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.DataAccess.Repositories;

namespace Makers.SmartParking.PakingManagement.Service.Controllers
{
    public class UnauthorizedPaymentController : ApiController
    {
        #region Dependencies

        private IParkingsRepository parkingsRepository;
        private IPaymentsRepository paymentsRepository;

        #endregion

        public UnauthorizedPaymentController(IParkingsRepository parkingsRepository, IPaymentsRepository paymentsRepository)
        {
            this.parkingsRepository = parkingsRepository;
            this.paymentsRepository = paymentsRepository;
        }

        public UnauthorizedPaymentController()
            :this(new ParkingsRepository(), new PaymentsRepository())
        {
            
        }

        [HttpPost]
        [Route("api/unauthorized-payment")]
        public IHttpActionResult Post(DoPaymentModel paymentModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // Find parking place
                    var parkingPlace = parkingsRepository.GetPlaceByCode(paymentModel.ParkingId, paymentModel.ParkingPlaceCode);
                    if (parkingPlace == null)
                        return NotFound();

                    var payment = new Payment();
                    payment.ParkingPlaceId = parkingPlace.Id;
                    payment.Duration = paymentModel.Duration;
                    payment.Price = (decimal)payment.Duration.TotalHours * 2;
                    payment.CreatedAt = DateTime.Now;

                    // Add payment
                    paymentsRepository.AddPayment(payment);

                    return Ok();
                }
                else
                {
                    return Content(HttpStatusCode.BadRequest, new ErrorModel(ModelState));
                }
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, e.Message);
            }
        }
    }
}
