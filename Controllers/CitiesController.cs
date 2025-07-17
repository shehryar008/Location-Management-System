using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LocationCRUD.Data;
using LocationCRUD.Models; // Ensure this includes both DTOs and ResponseDTOs

namespace LocationCRUD.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CitiesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CitiesController> _logger;

        public CitiesController(ApplicationDbContext context, ILogger<CitiesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CityResponseDto>>> GetCities()
        {
            try
            {
                return await _context.Cities
                    .Include(c => c.Province)
                    .ThenInclude(p => p.Country)
                    .OrderBy(c => c.Province.Country.Name)
                    .ThenBy(c => c.Province.Name)
                    .ThenBy(c => c.Name)
                    .Select(c => new CityResponseDto
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Code = c.Code,
                        ProvinceId = c.ProvinceId,
                        Province = new ProvinceResponseDto
                        {
                            Id = c.Province.Id,
                            Name = c.Province.Name,
                            Code = c.Province.Code,
                            CountryId = c.Province.CountryId,
                            Country = new CountryResponseDto
                            {
                                Id = c.Province.Country.Id,
                                Name = c.Province.Country.Name,
                                Code = c.Province.Country.Code
                            }
                        }
                    })
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching cities");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("by-province/{provinceId}")]
        public async Task<ActionResult<IEnumerable<CityResponseDto>>> GetCitiesByProvince(int provinceId)
        {
            try
            {
                return await _context.Cities
                    .Where(c => c.ProvinceId == provinceId)
                    .OrderBy(c => c.Name)
                    .Select(c => new CityResponseDto
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Code = c.Code,
                        ProvinceId = c.ProvinceId
                        // No need to include Province object here if not required by frontend
                    })
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching cities for province {ProvinceId}", provinceId);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CityResponseDto>> GetCity(int id)
        {
            try
            {
                var city = await _context.Cities
                    .Include(c => c.Province)
                    .ThenInclude(p => p.Country)
                    .Where(c => c.Id == id)
                    .Select(c => new CityResponseDto
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Code = c.Code,
                        ProvinceId = c.ProvinceId,
                        Province = new ProvinceResponseDto
                        {
                            Id = c.Province.Id,
                            Name = c.Province.Name,
                            Code = c.Province.Code,
                            CountryId = c.Province.CountryId,
                            Country = new CountryResponseDto
                            {
                                Id = c.Province.Country.Id,
                                Name = c.Province.Country.Name,
                                Code = c.Province.Country.Code
                            }
                        }
                    })
                    .FirstOrDefaultAsync();

                if (city == null)
                {
                    return NotFound();
                }

                return city;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching city {CityId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpPost]
        public async Task<ActionResult<CityResponseDto>> PostCity(CityDto cityDto)
        {
            try
            {
                _logger.LogInformation("Creating city: {@CityDto}", cityDto);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for city creation: {@ModelState}", ModelState);
                    return BadRequest(ModelState);
                }

                // Check if province exists
                var provinceExists = await _context.Provinces.AnyAsync(p => p.Id == cityDto.ProvinceId);
                if (!provinceExists)
                {
                    return BadRequest($"Province with ID {cityDto.ProvinceId} does not exist");
                }

                // Check if city already exists
                var existingCity = await _context.Cities
                    .FirstOrDefaultAsync(c => c.Name.ToLower() == cityDto.Name.ToLower() && c.ProvinceId == cityDto.ProvinceId);

                if (existingCity != null)
                {
                    _logger.LogInformation("City already exists: {CityName}", cityDto.Name);
                    // Return existing city as a DTO
                    var existingCityDto = await _context.Cities
                        .Include(c => c.Province)
                        .ThenInclude(p => p.Country)
                        .Where(c => c.Id == existingCity.Id)
                        .Select(c => new CityResponseDto
                        {
                            Id = c.Id,
                            Name = c.Name,
                            Code = c.Code,
                            ProvinceId = c.ProvinceId,
                            Province = new ProvinceResponseDto
                            {
                                Id = c.Province.Id,
                                Name = c.Province.Name,
                                Code = c.Province.Code,
                                CountryId = c.Province.CountryId,
                                Country = new CountryResponseDto { Id = c.Province.Country.Id, Name = c.Province.Country.Name, Code = c.Province.Country.Code }
                            }
                        })
                        .FirstOrDefaultAsync();
                    return Ok(existingCityDto);
                }

                var city = new City
                {
                    Name = cityDto.Name,
                    Code = cityDto.Code,
                    ProvinceId = cityDto.ProvinceId
                };

                _context.Cities.Add(city);
                await _context.SaveChangesAsync();

                // Return with province and country included as DTOs
                var createdCityDto = await _context.Cities
                    .Include(c => c.Province)
                    .ThenInclude(p => p.Country)
                    .Where(c => c.Id == city.Id)
                    .Select(c => new CityResponseDto
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Code = c.Code,
                        ProvinceId = c.ProvinceId,
                        Province = new ProvinceResponseDto
                        {
                            Id = c.Province.Id,
                            Name = c.Province.Name,
                            Code = c.Province.Code,
                            CountryId = c.Province.CountryId,
                            Country = new CountryResponseDto { Id = c.Province.Country.Id, Name = c.Province.Country.Name, Code = c.Province.Country.Code }
                        }
                    })
                    .FirstOrDefaultAsync();

                _logger.LogInformation("City created successfully: {CityId}", city.Id);
                return CreatedAtAction(nameof(GetCity), new { id = city.Id }, createdCityDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating city: {@CityDto}", cityDto);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCity(int id, CityDto cityDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var city = await _context.Cities.FindAsync(id);
                if (city == null)
                {
                    return NotFound();
                }

                city.Name = cityDto.Name;
                city.Code = cityDto.Code;
                city.ProvinceId = cityDto.ProvinceId;

                await _context.SaveChangesAsync();
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating city {CityId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCity(int id)
        {
            try
            {
                var city = await _context.Cities.FindAsync(id);
                if (city == null)
                {
                    return NotFound();
                }

                _context.Cities.Remove(city);
                await _context.SaveChangesAsync();

                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting city {CityId}", id);
                return StatusCode(500, "Internal server error");
            }
        }
    }
}
