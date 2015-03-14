using Makers.SmartParking.Domain.BusinessObjects;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.ServicesSecurity.Abstract
{
    public interface IUserManager
    {
        Task<IdentityResult> CreateAsync(User user, string password);

        Task SendEmailAsync(int userId, string subject, string body);

        Task<User> FindAsync(string userName, string password);

        Task<User> FindByNameAsync(string userName);

        Task<User> FindByEmailAsync(string email);

        Task<User> FindByIdAsync(int userId);
    }
}
