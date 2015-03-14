using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.Users.Service.Models.MappingProfiles
{
    public class UserModelMappingProfile : Profile
    {
        protected override void Configure()
        {
            Mapper.CreateMap<User, UserModel>();
        }
    }
}