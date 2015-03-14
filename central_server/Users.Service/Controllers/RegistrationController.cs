using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.ServicesInfrastructure.Models;
using Makers.SmartParking.ServicesSecurity.Abstract;
using Makers.SmartParking.Users.Service.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web;
using Microsoft.AspNet.Identity.Owin;

namespace Makers.SmartParking.Users.Service.Controllers
{
    public class RegistrationController : ApiController
    {
        #region Dependencies

        private IMappingEngine mapper;
        private IUserManager userManager;

        #endregion

        public RegistrationController(IMappingEngine mapper, IUserManager userManager)
        {
            this.mapper = mapper;
            this.userManager = userManager;
        }

        public RegistrationController()
            : this(Mapper.Engine, System.Web.HttpContext.Current.GetOwinContext().Get<Makers.SmartParking.ServicesSecurity.Concrete.UserManager>())
        {
            
        }

        public async Task<IHttpActionResult> Post(RegistrationModel model)
        {
            try
            {
                if (model == null)
                    return Content(HttpStatusCode.BadRequest, new ErrorModel("User data are required."));

                if (ModelState.IsValid)
                {
                    // Check username
                    var existingUserByUsername = await userManager.FindByNameAsync(model.Username);
                    if (existingUserByUsername != null)
                    {
                        ModelState.AddModelError("Username", "Username is taken. Please choose another one.");
                    }

                    // Check email
                    var existingUserByEmail = await userManager.FindByEmailAsync(model.Email);
                    if (existingUserByEmail != null)
                    {
                        ModelState.AddModelError("Email", "User with entered e-mail alraedy exists.");
                    }

                    if (ModelState.IsValid)
                    {
                        var user = mapper.Map<User>(model);
                        user.Balance = 100;
                        var result = await userManager.CreateAsync(user, model.Password);

                        if (result.Succeeded)
                        {
                            return Ok();
                        }
                        else
                        {
                            var errors = String.Join(Environment.NewLine, result.Errors.ToArray());
                            return Content(HttpStatusCode.BadRequest, new ErrorModel(errors));
                        }
                    }
                }

                return Content(HttpStatusCode.BadRequest, new ErrorModel(ModelState));
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, new ErrorModel(e.Message));
            }
        }
    }
}
