namespace LocationCRUD.Models
{
    // Response DTOs to avoid circular references in JSON serialization
    public class CountryResponseDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
    }

    public class ProvinceResponseDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public int CountryId { get; set; }
        public CountryResponseDto? Country { get; set; } // Include Country, but not its Provinces
    }

    public class CityResponseDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public int ProvinceId { get; set; }
        public ProvinceResponseDto? Province { get; set; } // Include Province, but not its Cities
    }

    public class LocationResponseDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public int CityId { get; set; }
        public CityResponseDto? City { get; set; } // Include City, but not its Locations
    }
}
