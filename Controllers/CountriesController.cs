using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LocationCRUD.Data;
using LocationCRUD.Models; // Ensure this includes both DTOs and ResponseDTOs

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
        public async Task<ActionResult<IEnumerable<CountryResponseDto>>> GetCountries()
        {
            try
            {
                return await _context.Countries
                    .OrderBy(c => c.Name)
                    .Select(c => new CountryResponseDto
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Code = c.Code
                    })
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching countries");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CountryResponseDto>> GetCountry(int id)
        {
            try
            {
                var country = await _context.Countries
                    .Where(c => c.Id == id)
                    .Select(c => new CountryResponseDto
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Code = c.Code
                    })
                    .FirstOrDefaultAsync();

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
        public async Task<ActionResult<CountryResponseDto>> PostCountry(CountryDto countryDto)
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
                    // Return existing country as a DTO
                    return Ok(new CountryResponseDto { Id = existingCountry.Id, Name = existingCountry.Name, Code = existingCountry.Code });
                }

                var country = new Country
                {
                    Name = countryDto.Name,
                    Code = countryDto.Code
                };

                _context.Countries.Add(country);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Country created successfully: {CountryId}", country.Id);
                // Return the newly created country as a DTO
                return CreatedAtAction(nameof(GetCountry), new { id = country.Id }, new CountryResponseDto { Id = country.Id, Name = country.Name, Code = country.Code });
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
