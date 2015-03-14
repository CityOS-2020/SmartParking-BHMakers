using Makers.SmartParking.Domain.BusinessObjects;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.ServicesSecurity.Concrete
{
    public class UserValidator : UserValidator<User, int>
    {
        public UserValidator(UserManager<User, int> manager)
            : base(manager)
        { }
    }
}
