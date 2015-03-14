using AutoMapper;
using Makers.SmartParking.Domain.BusinessObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Makers.SmartParking.PakingManagement.Service.Models.MappingProfiles
{
    public class PaymentsModelMappingProfile : Profile
    {
        protected override void Configure()
        {
            Mapper.CreateMap<DoPaymentModel, Payment>()
                .ForMember(p => p.CreatedAt, m => m.MapFrom(o => DateTime.Now));
        }
    }
}