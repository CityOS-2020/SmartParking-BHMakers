using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.BusinessObjects
{
    public class Role : IdentityRole<int, UserRole>
    {
    }
}
