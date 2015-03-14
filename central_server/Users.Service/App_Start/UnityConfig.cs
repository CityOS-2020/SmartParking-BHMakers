using AutoMapper;
using Microsoft.Practices.Unity;
using System.Web.Http;
using Unity.WebApi;

namespace Makers.SmartParking.Users.Service
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
			var container = new UnityContainer();
            container.RegisterInstance<IMappingEngine>(Mapper.Engine);
            
            // register all your components with the container here
            // it is NOT necessary to register your controllers
            
            // e.g. container.RegisterType<ITestService, TestService>();
            
            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
        }
    }
}