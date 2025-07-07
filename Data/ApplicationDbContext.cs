using Microsoft.EntityFrameworkCore;
using LocationCRUD.Models;

namespace LocationCRUD.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Country> Countries { get; set; }
        public DbSet<Province> Provinces { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<Location> Locations { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Location>()
                .Property(l => l.Latitude)
                .HasPrecision(18, 6);

            modelBuilder.Entity<Location>()
                .Property(l => l.Longitude)
                .HasPrecision(18, 6);

            modelBuilder.Entity<Province>()
                .HasOne(p => p.Country)
                .WithMany(c => c.Provinces)
                .HasForeignKey(p => p.CountryId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<City>()
                .HasOne(c => c.Province)
                .WithMany(p => p.Cities)
                .HasForeignKey(c => c.ProvinceId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Location>()
                .HasOne(l => l.City)
                .WithMany(c => c.Locations)
                .HasForeignKey(l => l.CityId)
                .OnDelete(DeleteBehavior.Cascade);

        }
    }
}
