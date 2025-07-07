using System.ComponentModel.DataAnnotations;

namespace LocationCRUD.Models
{
    public class Country
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "Country name is required")]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(10)]
        public string Code { get; set; } = string.Empty;
        
        public virtual ICollection<Province> Provinces { get; set; } = new List<Province>();
    }
}