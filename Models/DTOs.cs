using System.ComponentModel.DataAnnotations;

namespace LocationCRUD.Models
{
    public class CountryDto
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "Country name is required")]
        public string Name { get; set; } = string.Empty;
        
        public string Code { get; set; } = string.Empty;
    }

    public class ProvinceDto
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "Province name is required")]
        public string Name { get; set; } = string.Empty;
        
        public string Code { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "Country ID is required")]
        public int CountryId { get; set; }
    }

    public class CityDto
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "City name is required")]
        public string Name { get; set; } = string.Empty;
        
        public string Code { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "Province ID is required")]
        public int ProvinceId { get; set; }
    }

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
}
