using Makers.SmartParking.DataAccess;
using Makers.SmartParking.ServicesSecurity.Concrete;
using Makers.SmartParking.Users.Service.Infrastructure;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security.OAuth;
using Owin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

[assembly: OwinStartup(typeof(Makers.SmartParking.Users.Service.Startup))]
namespace Makers.SmartParking.Users.Service
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAspIdentity(app);
            ConfigureOAuth(app);

            //GlobalConfiguration.Configuration.DependencyResolver = new Unity.WebApi.UnityDependencyResolver(null);

            HttpConfiguration config = new HttpConfiguration();
            WebApiConfig.Register(config);
            app.UseWebApi(config);
        }

        public void ConfigureOAuth(IAppBuilder app)
        {
            OAuthAuthorizationServerOptions OAuthServerOptions = new OAuthAuthorizationServerOptions()
            {
                AllowInsecureHttp = true,
                TokenEndpointPath = new PathString("/api/token"),
                AccessTokenExpireTimeSpan = TimeSpan.FromDays(1),
                Provider = new MyAuthorizationServerProvider(new UserManager(new UserStore(new SmartParkingContext())))
            };

            // Token Generation
            app.UseOAuthAuthorizationServer(OAuthServerOptions);
            app.UseOAuthBearerAuthentication(new OAuthBearerAuthenticationOptions());

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