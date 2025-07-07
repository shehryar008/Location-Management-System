using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LocationCRUD.Data;
using LocationCRUD.Models;

namespace LocationCRUD.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CountriesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CountriesController> _logger;

        public CountriesController(ApplicationDbContext context, ILogger<CountriesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Country>>> GetCountries()
        {
            try
            {
                return await _context.Countries.OrderBy(c => c.Name).ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching countries");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Country>> GetCountry(int id)
        {
            try
            {
                var country = await _context.Countries
                    .Include(c => c.Provinces)
                    .FirstOrDefaultAsync(c => c.Id == id);

                if (country == null)
                {
                    return NotFound();
                }

                return country;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching country {CountryId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpPost]
        public async Task<ActionResult<Country>> PostCountry(CountryDto countryDto)
        {
            try
            {
                _logger.LogInformation("Creating country: {@CountryDto}", countryDto);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for country creation: {@ModelState}", ModelState);
                    return BadRequest(ModelState);
                }

                // Check if country already exists
                var existingCountry = await _context.Countries
                    .FirstOrDefaultAsync(c => c.Name.ToLower() == countryDto.Name.ToLower());

                if (existingCountry != null)
                {
                    _logger.LogInformation("Country already exists: {CountryName}", countryDto.Name);
                    return Ok(existingCountry);
                }

                var country = new Country
                {
                    Name = countryDto.Name,
                    Code = countryDto.Code
                };

                _context.Countries.Add(country);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Country created successfully: {CountryId}", country.Id);
                return CreatedAtAction(nameof(GetCountry), new { id = country.Id }, country);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating country: {@CountryDto}", countryDto);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCountry(int id, CountryDto countryDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var country = await _context.Countries.FindAsync(id);
                if (country == null)
                {
                    return NotFound();
                }

                country.Name = countryDto.Name;
                country.Code = countryDto.Code;

                await _context.SaveChangesAsync();
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating country {CountryId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCountry(int id)
        {
            try
            {
                var country = await _context.Countries.FindAsync(id);
                if (country == null)
                {
                    return NotFound();
                }

                _context.Countries.Remove(country);
                await _context.SaveChangesAsync();

                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting country {CountryId}", id);
                return StatusCode(500, "Internal server error");
            }
        }
    }
}
