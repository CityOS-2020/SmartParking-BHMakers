using System.Net.Http.Formatting;
using AutoMapper;
using Makers.SmartParking.PakingManagement.Service.Models.MappingProfiles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using Newtonsoft.Json.Serialization;

namespace Makers.SmartParking.PakingManagement.Service
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            // JSON camel case
            var jsonFormatter = config.Formatters.OfType<JsonMediaTypeFormatter>().First();
            jsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();

            // Mappers
            Mapper.AddProfile<GpsCoordinatesMappingProfile>();
            Mapper.AddProfile<ParkingModelMappingProfile>();
            Mapper.AddProfile<ParkingPlaceModelMappingProfile>();
            Mapper.AddProfile<PaymentsModelMappingProfile>();
        }
    }
}
