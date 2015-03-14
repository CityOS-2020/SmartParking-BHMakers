using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.PakingManagement.Service.Models;
using Makers.SmartParking.ServicesInfrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;
using Microsoft.AspNet.Identity;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.ServicesSecurity.Abstract;
using System.Threading.Tasks;
using Makers.SmartParking.DataAccess.Repositories;
using Microsoft.AspNet.Identity.Owin;

namespace Makers.SmartParking.PakingManagement.Service.Controllers
{
    public class PaymentsController : ApiController
    {
        #region Dependencies

        private IMappingEngine mapper;
        private IPaymentsRepository paymentsRepository;
        private IUserManager userManager;
        private IParkingsRepository parkingsRepository;

        #endregion

        public PaymentsController(IMappingEngine mapper, IPaymentsRepository paymentsRepository, IUserManager userManager, IParkingsRepository parkingsRepository)
        {
            this.mapper = mapper;
            this.paymentsRepository = paymentsRepository;
            this.userManager = userManager;
            this.parkingsRepository = parkingsRepository;
        }

        public PaymentsController()
            : this(Mapper.Engine, new PaymentsRepository(), System.Web.HttpContext.Current.GetOwinContext().Get<Makers.SmartParking.ServicesSecurity.Concrete.UserManager>(), new ParkingsRepository())
        { }

        [Authorize]
        public async Task<IHttpActionResult> Post(DoPaymentModel paymentModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // Find parking place
                    var parkingPlace = parkingsRepository.GetPlaceByCode(paymentModel.ParkingId, paymentModel.ParkingPlaceCode);
                    if (parkingPlace == null)
                        return NotFound();

                    var userId = User.Identity.GetUserId<int>();
                    var payment = new Payment();
                    payment.ParkingPlaceId = parkingPlace.Id;
                    payment.UserId = userId;
                    payment.Duration = paymentModel.Duration;
                    payment.Price = (decimal)payment.Duration.TotalHours * 2;
                    payment.CreatedAt = DateTime.Now;

                    // Check if user has enough money
                    var user = await userManager.FindByIdAsync(userId);
                    if (user.Balance <= 0)
                        return Content(HttpStatusCode.BadRequest, new ErrorModel("You don't have enough money to play."));

                    // Add payment
                    paymentsRepository.AddPayment(payment);

                    // Take money from user
                    paymentsRepository.TakeMoneyFromUser(userId, payment.Price);

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