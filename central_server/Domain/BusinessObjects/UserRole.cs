using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    public class UserRole : IdentityUserRole<int>
    {
        public Role Role { get; set; }
        public User User { get; set; }
    }
}
