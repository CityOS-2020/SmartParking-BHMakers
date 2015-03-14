using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace Makers.SmartParking.DataAccess.Infrastructure
{
    public class RepositoryBase
    {
        protected SmartParkingContext GetContext()
        {
            return new SmartParkingContext();
        }

        protected IQueryable<TEntity> ApplyInclude<TEntity>(IQueryable<TEntity> queryable, Expression<Func<TEntity, object>>[] includes) where TEntity : class
        {
            if (includes != null && includes.Count() > 0)
            {
                foreach (var include in includes)
                    queryable = queryable.Include(include);
            }

            return queryable;
        }
    }
}
