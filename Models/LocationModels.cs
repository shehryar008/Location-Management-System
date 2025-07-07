using System.ComponentModel.DataAnnotations;

namespace LocationManager.Models
{
    public class Country
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        public virtual ICollection<Province> Provinces { get; set; } = new List<Province>();
        public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
    }

    public class Province
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public int CountryId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        public virtual Country Country { get; set; } = null!;
        public virtual ICollection<City> Cities { get; set; } = new List<City>();
        public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
    }

    public class City
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public int ProvinceId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
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
        
        public int CountryId { get; set; }
        public int ProvinceId { get; set; }
        public int CityId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        public virtual Country Country { get; set; } = null!;
        public virtual Province Province { get; set; } = null!;
        public virtual City City { get; set; } = null!;
    }

    // DTOs for API responses
    public class LocationDto
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "Location name is required")]
        public string Name { get; set; } = string.Empty;
        
        public string Address { get; set; } = string.Empty;
        
        public decimal? Latitude { get; set; }
        
        public decimal? Longitude { get; set; }
        
        [Required(ErrorMessage = "City ID is required")]
        public int CityId { get; set; }
    }

    public class CreateLocationDto
    {
        [Required]
        public string Name { get; set; } = string.Empty;
        
        [Required]
        public int CountryId { get; set; }
        
        [Required]
        public int ProvinceId { get; set; }
        
        [Required]
        public int CityId { get; set; }
    }

    public class UpdateLocationDto
    {
        [Required]
        public string Name { get; set; } = string.Empty;
        
        [Required]
        public int CountryId { get; set; }
        
        [Required]
        public int ProvinceId { get; set; }
        
        [Required]
        public int CityId { get; set; }
    }
}
