using System.ComponentModel.DataAnnotations;

namespace LocationCRUD.Models
{
    public class City
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "City name is required")]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(10)]
        public string Code { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "Province ID is required")]
        public int ProvinceId { get; set; }
        public virtual Province Province { get; set; } = null!;
        
        public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
    }
}