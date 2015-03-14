using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.Users.Service.Models
{
    public class RegistrationModel
    {
        [Required(ErrorMessage="Username is required.")]
        [RegularExpression(@"^[a-zA-Z0-9\-_\.]+$", ErrorMessage = "Username can only contain letters, numbers and some special characters ('.', '-' and '_').")]
        [MinLength(5, ErrorMessage = "Minimum length of username is 5 characters.")]
        [MaxLength(25, ErrorMessage = "Maximum length of username if 25 characters.")]
        public string Username { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        [MinLength(5, ErrorMessage = "Minimum length of password is 5 characters.")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email address")]
        public string Email { get; set; }

        [Required(ErrorMessage="First name is required.")]
        public string FirstName { get; set; }

        [Required(ErrorMessage="Last name is required.")]
        public string LastName { get; set; }

        [Required(ErrorMessage="Address is required.")]
        public string Address { get; set; }

        [Required(ErrorMessage="City is required.")]
        public string City { get; set; }
    }
}