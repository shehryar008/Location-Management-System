using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LocationCRUD.Data;
using LocationCRUD.Models;

namespace LocationCRUD.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProvincesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<ProvincesController> _logger;

        public ProvincesController(ApplicationDbContext context, ILogger<ProvincesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Province>>> GetProvinces()
        {
            try
            {
                return await _context.Provinces
                    .Include(p => p.Country)
                    .OrderBy(p => p.Country.Name)
                    .ThenBy(p => p.Name)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching provinces");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("by-country/{countryId}")]
        public async Task<ActionResult<IEnumerable<Province>>> GetProvincesByCountry(int countryId)
        {
            try
            {
                return await _context.Provinces
                    .Where(p => p.CountryId == countryId)
                    .OrderBy(p => p.Name)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching provinces for country {CountryId}", countryId);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Province>> GetProvince(int id)
        {
            try
            {
                var province = await _context.Provinces
                    .Include(p => p.Country)
                    .Include(p => p.Cities)
                    .FirstOrDefaultAsync(p => p.Id == id);

                if (province == null)
                {
                    return NotFound();
                }

                return province;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching province {ProvinceId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpPost]
        public async Task<ActionResult<Province>> PostProvince(ProvinceDto provinceDto)
        {
            try
            {
                _logger.LogInformation("Creating province: {@ProvinceDto}", provinceDto);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for province creation: {@ModelState}", ModelState);
                    return BadRequest(ModelState);
                }

                // Check if country exists
                var countryExists = await _context.Countries.AnyAsync(c => c.Id == provinceDto.CountryId);
                if (!countryExists)
                {
                    return BadRequest($"Country with ID {provinceDto.CountryId} does not exist");
                }

                // Check if province already exists
                var existingProvince = await _context.Provinces
                    .FirstOrDefaultAsync(p => p.Name.ToLower() == provinceDto.Name.ToLower() && p.CountryId == provinceDto.CountryId);

                if (existingProvince != null)
                {
                    _logger.LogInformation("Province already exists: {ProvinceName}", provinceDto.Name);
                    return Ok(existingProvince);
                }

                var province = new Province
                {
                    Name = provinceDto.Name,
                    Code = provinceDto.Code,
                    CountryId = provinceDto.CountryId
                };

                _context.Provinces.Add(province);
                await _context.SaveChangesAsync();

                // Return with country included
                var createdProvince = await _context.Provinces
                    .Include(p => p.Country)
                    .FirstOrDefaultAsync(p => p.Id == province.Id);

                _logger.LogInformation("Province created successfully: {ProvinceId}", province.Id);
                return CreatedAtAction(nameof(GetProvince), new { id = province.Id }, createdProvince);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating province: {@ProvinceDto}", provinceDto);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutProvince(int id, ProvinceDto provinceDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var province = await _context.Provinces.FindAsync(id);
                if (province == null)
                {
                    return NotFound();
                }

                province.Name = provinceDto.Name;
                province.Code = provinceDto.Code;
                province.CountryId = provinceDto.CountryId;

                await _context.SaveChangesAsync();
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating province {ProvinceId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProvince(int id)
        {
            try
            {
                var province = await _context.Provinces.FindAsync(id);
                if (province == null)
                {
                    return NotFound();
                }

                _context.Provinces.Remove(province);
                await _context.SaveChangesAsync();

                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting province {ProvinceId}", id);
                return StatusCode(500, "Internal server error");
            }
        }
    }
}
