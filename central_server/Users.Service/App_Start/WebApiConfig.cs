using AutoMapper;
using Makers.SmartParking.Users.Service.Models.MappingProfiles;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Formatting;
using System.Web.Http;

namespace Makers.SmartParking.Users.Service
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            //UnityConfig.RegisterComponents();  

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

            // Configure mapper
            Mapper.AddProfile<RegistrationModelMappingProfile>();
            Mapper.AddProfile<UserModelMappingProfile>();
        }
    }
}
