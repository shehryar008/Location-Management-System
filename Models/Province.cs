using System.ComponentModel.DataAnnotations;

namespace LocationCRUD.Models
{
    public class Province
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "Province name is required")]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(10)]
        public string Code { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "Country ID is required")]
        public int CountryId { get; set; }
        public virtual Country Country { get; set; } = null!;
        
        public virtual ICollection<City> Cities { get; set; } = new List<City>();
    }
}