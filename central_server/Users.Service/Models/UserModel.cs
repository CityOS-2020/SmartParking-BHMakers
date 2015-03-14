using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.Users.Service.Models
{
    public class UserModel
    {
        public string Id { get; set; }

        public string Username { get; set; }

        public string Email { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Address { get; set; }

        public string City { get; set; }

        public decimal Balance { get; set; }
    }
}