using Makers.SmartParking.DataAccess.Infrastructure;
using Makers.SmartParking.Domain.Abstract;
using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.DataAccess.Repositories
{
    public class PaymentsRepository : RepositoryBase, IPaymentsRepository
    {
        public void AddPayment(Payment payment)
        {
            using (var context = GetContext())
            {
                context.Payments.Add(payment);
                context.SaveChanges();
            }
        }

        public void TakeMoneyFromUser(int userId, decimal amount)
        {
            using (var context = GetContext())
            {
                var user = context.Users.Find(userId);
                if (user == null)
                    throw new Exception("Can't find user.");

                user.Balance -= amount;

                context.SaveChanges();
            }
        }
    }
}
