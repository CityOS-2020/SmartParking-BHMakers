using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using Makers.SmartParking.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models.MappingProfiles
{
    public class ParkingModelMappingProfile : Profile
    {
        protected override void Configure()
        {
            Mapper.CreateMap<Parking, ParkingModel>()
                .ForMember(o => o.GpsCoordinate, m => m.MapFrom(o => o.GpsPosition))
                .ForMember(o => o.TotalPlaces, m => m.MapFrom(o => o.ParkingPlaces != null ? o.ParkingPlaces.Count() : 0))
                .ForMember(o => o.FreePlaces, m => m.MapFrom(o => o.ParkingPlaces != null ? o.ParkingPlaces.Count(pl => pl.CurrentStatus != null && pl.CurrentStatus.Status == ParkingPlaceStatus.Free) : 0))
                .ForMember(o => o.BlockedSensors, m => m.MapFrom( o => o.ParkingPlaces != null ? o.ParkingPlaces.Count(pl => pl.CurrentStatus != null && pl.CurrentStatus.Status == ParkingPlaceStatus.Blocked): 0));
        }
    }
}