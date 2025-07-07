using System.ComponentModel.DataAnnotations;

namespace LocationCRUD.Models
{
    public class Location
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(200)]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string Address { get; set; } = string.Empty;
        
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        
        public int CityId { get; set; }
        public virtual City City { get; set; } = null!;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}