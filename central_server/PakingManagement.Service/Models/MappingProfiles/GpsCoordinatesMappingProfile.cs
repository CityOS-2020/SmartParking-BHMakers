using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models.MappingProfiles
{
    public class GpsCoordinatesMappingProfile : Profile
    {
        protected override void Configure()
        {
            Mapper.CreateMap<GpsCoordinate, GpsCoordinateModel>();
        }
    }
}