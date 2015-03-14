using Makers.SmartParking.ServicesSecurity.Abstract;
using Makers.SmartParking.ServicesSecurity.Concrete;
using Microsoft.Owin.Security.OAuth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity.Owin;

namespace Makers.SmartParking.Users.Service.Infrastructure
{
    public class MyAuthorizationServerProvider : OAuthAuthorizationServerProvider
    {
        #region Dependencies

        private IUserManager userManager;

        #endregion

        public MyAuthorizationServerProvider(IUserManager userManager)
        {
            this.userManager = userManager;
        }

        public MyAuthorizationServerProvider()
            : this(System.Web.HttpContext.Current.GetOwinContext().Get<Makers.SmartParking.ServicesSecurity.Concrete.UserManager>())
        {
            
        }

        public override async Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "*" });

                var user = await userManager.FindAsync(context.UserName, context.Password);

                if (user == null)
                {
                    context.SetError("invalid_credentials", "The user name or password is incorrect.");
                    return;
                }

            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim(ClaimTypes.Name, context.UserName));
            identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()));

            context.Validated(identity);
        }
    }
}