using Makers.SmartParking.Domain.BusinessObjects;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.ServicesSecurity.Concrete
{
    public class UserStore : UserStore<User, Role, int, UserLogin, UserRole, UserClaim>, IUserStore<User, int>
    {
        public UserStore(DbContext context)
            : base(context)
        { }
    }
}
