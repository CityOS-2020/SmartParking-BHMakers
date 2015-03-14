using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Microsoft.AspNet.Identity;
using Makers.SmartParking.ServicesSecurity.Abstract;
using System.Threading.Tasks;
using AutoMapper;
using Makers.SmartParking.ServicesInfrastructure.Models;
using Makers.SmartParking.Users.Service.Models;
using System.Web;
using Microsoft.AspNet.Identity.Owin;

namespace Makers.SmartParking.Users.Service.Controllers
{
    public class AccountController : ApiController
    {
        #region Dependencies

        private IUserManager userManager;
        private IMappingEngine mapper;

        #endregion

        public AccountController(IUserManager userManager, IMappingEngine mapper)
        {
            this.userManager = userManager;
            this.mapper = mapper;
        }

        public AccountController()
            : this(System.Web.HttpContext.Current.GetOwinContext().Get<Makers.SmartParking.ServicesSecurity.Concrete.UserManager>(), Mapper.Engine)
        {
            
        }

        [Authorize]
        public async Task<IHttpActionResult> Get()
        {
            try
            {
                var userId = User.Identity.GetUserId<int>();
                var user = await userManager.FindByIdAsync(userId);

                if (user == null)
                    return NotFound();

                var model = mapper.Map<UserModel>(user);
                return Ok(model);
            }
            catch (Exception e)
            {
                return Content(HttpStatusCode.InternalServerError, new ErrorModel(e.Message));
            }
        }
    }
}
