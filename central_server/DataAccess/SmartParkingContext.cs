using Makers.SmartParking.Domain.BusinessObjects;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.DataAccess
{
    public class SmartParkingContext : IdentityDbContext<User, Role, int, UserLogin, UserRole, UserClaim>
    {
        public DbSet<Parking> Parkings { get; set; }

        public DbSet<ParkingPlace> ParkingPlaces { get; set; }

        public DbSet<Payment> Payments { get; set; }

        public DbSet<ParkingPlaceStatusChange> ParkingPlaceStatusChanges { get; set; }

        public SmartParkingContext()
            : base("SmartParkingContext")
        { }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>().ToTable("Users");
            modelBuilder.Entity<Role>().ToTable("Roles");
            modelBuilder.Entity<UserRole>().ToTable("UserRoles");
            modelBuilder.Entity<UserClaim>().ToTable("UserClaims");
            modelBuilder.Entity<UserLogin>().ToTable("UserLogins");
            
            modelBuilder.Entity<ParkingPlace>()
                .HasMany<ParkingPlaceStatusChange>(pp => pp.StatusChanges)
                .WithRequired(d => d.ParkingPlace);

            modelBuilder.ComplexType<GpsCoordinate>().Property(o => o.Latitude).HasPrecision(15, 12);
            modelBuilder.ComplexType<GpsCoordinate>().Property(o => o.Longitude).HasPrecision(15, 12);
        }
    }
}
