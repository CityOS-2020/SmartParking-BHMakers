using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.Domain.Abstract
{
    public interface IPaymentsRepository
    {
        void AddPayment(Payment payment);

        void TakeMoneyFromUser(int userId, decimal amount);
    }
}
