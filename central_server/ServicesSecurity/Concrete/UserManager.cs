using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.ServicesSecurity.Abstract;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.ServicesSecurity.Concrete
{
    public class UserManager : UserManager<User, int>, IUserManager
    {
        public UserManager(IUserStore<User, int> userStore)
            : base(userStore)
        {
            // Configure validation logic for usernames
            this.UserValidator = new UserValidator(this)
            {
                AllowOnlyAlphanumericUserNames = true,
                RequireUniqueEmail = true,
            };

            // Configure validation logic for passwords
            this.PasswordValidator = new PasswordValidator
            {
                RequiredLength = 5,
                RequireNonLetterOrDigit = false,
                RequireDigit = false,
                RequireLowercase = false,
                RequireUppercase = false,
            };

            // Configure user lockout defaults
            this.UserLockoutEnabledByDefault = true;
            this.DefaultAccountLockoutTimeSpan = TimeSpan.FromMinutes(5);
            this.MaxFailedAccessAttemptsBeforeLockout = 5;
        }
    }
}
