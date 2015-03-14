using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models.MappingProfiles
{
    public class ParkingPlaceModelMappingProfile : Profile
    {
        protected override void Configure()
        {
            Mapper.CreateMap<ParkingPlace, ParkingPlaceModel>()
                .ForMember(pp => pp.Status, m => m.MapFrom(o => o.CurrentStatus != null ? (ParkingPlaceStatusModel) ((int) o.CurrentStatus.Status) : ParkingPlaceStatusModel.Unknown));
        }
    }
}