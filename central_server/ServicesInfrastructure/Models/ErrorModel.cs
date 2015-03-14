using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.ModelBinding;

namespace Makers.SmartParking.ServicesInfrastructure.Models
{
    public class ErrorModel
    {
        public string Message { get; set; }

        public Dictionary<string, string[]> ModelState { get; set; }

        public ErrorModel(string message)
        {
            this.Message = message;
        }

        public ErrorModel(IEnumerable<string> messages)
        {
            this.Message = String.Join(Environment.NewLine, messages.ToArray());
        }

        public ErrorModel(ModelStateDictionary modelState, string prefix = null)
        {
            var notEmpty = modelState.Where(o => o.Value.Errors.Count > 0);
            this.ModelState = notEmpty.ToDictionary(o =>
            {
                var property = o.Key;

                if (!String.IsNullOrWhiteSpace(prefix))
                {
                    property = o.Key.Replace(prefix + ".", "");
                }

                return Char.ToLowerInvariant(property[0]) + property.Substring(1);
            },
                // Value
                o => o.Value.Errors.Select(e =>
                {
                    if (!String.IsNullOrWhiteSpace(e.ErrorMessage))
                        return e.ErrorMessage;
                    else if (e.Exception != null)
                        return e.Exception.Message;
                    else
                        return null;
                }).ToArray());
        }
    }
}
