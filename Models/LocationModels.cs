using System.ComponentModel.DataAnnotations;

namespace LocationCRUD.Models
{
    public class Country
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public string Code { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        
        public virtual ICollection<Province> Provinces { get; set; } = new List<Province>();
    }

    public class Province
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public string Code { get; set; } = string.Empty;
        public int CountryId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        
        public virtual Country Country { get; set; } = null!;
        public virtual ICollection<City> Cities { get; set; } = new List<City>();
    }

    public class City
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public string Code { get; set; } = string.Empty;
        public int ProvinceId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        
        public virtual Province Province { get; set; } = null!;
        public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
    }

    public class Location
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(200)]
        public string Name { get; set; } = string.Empty;
        
        public string Address { get; set; } = string.Empty;
        
        public decimal? Latitude { get; set; }
        
        public decimal? Longitude { get; set; }
        
        public int CityId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        
        public virtual City City { get; set; } = null!;
    }
}
