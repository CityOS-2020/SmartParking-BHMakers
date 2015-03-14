using Makers.SmartParking.DataAccess;
using Makers.SmartParking.ServicesSecurity.Concrete;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security.OAuth;
using Owin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

[assembly: OwinStartup(typeof(Makers.SmartParking.PakingManagement.Service.Startup))]
namespace Makers.SmartParking.PakingManagement.Service
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAspIdentity(app);
            ConfigureOAuth(app);

            HttpConfiguration config = new HttpConfiguration();
            WebApiConfig.Register(config);
            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
            app.UseWebApi(config);
        }

        private void ConfigureOAuth(IAppBuilder app)
        {
            //Token Consumption
            app.UseOAuthBearerAuthentication(new OAuthBearerAuthenticationOptions
            {
            });
        }

        private void ConfigureAspIdentity(IAppBuilder app)
        {
            app.CreatePerOwinContext(() => new SmartParkingContext());
            app.CreatePerOwinContext<UserManager>(createUserManager);
            //app.CreatePerOwinContext<RoleManager>(createRoleManager);
        }

        private UserManager createUserManager(IdentityFactoryOptions<UserManager> options, IOwinContext context)
        {
            return new UserManager(new UserStore(context.Get<SmartParkingContext>()));
        }

    }
}