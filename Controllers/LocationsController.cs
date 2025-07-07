using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LocationCRUD.Data;
using LocationCRUD.Models;

namespace LocationCRUD.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LocationsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<LocationsController> _logger;

        public LocationsController(ApplicationDbContext context, ILogger<LocationsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Location>>> GetLocations()
        {
            try
            {
                return await _context.Locations
                    .Include(l => l.City)
                    .ThenInclude(c => c.Province)
                    .ThenInclude(p => p.Country)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching locations");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Location>> GetLocation(int id)
        {
            try
            {
                var location = await _context.Locations
                    .Include(l => l.City)
                    .ThenInclude(c => c.Province)
                    .ThenInclude(p => p.Country)
                    .FirstOrDefaultAsync(l => l.Id == id);

                if (location == null)
                {
                    return NotFound();
                }

                return location;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching location {LocationId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpPost]
        public async Task<ActionResult<Location>> PostLocation(LocationDto locationDto)
        {
            try
            {
                _logger.LogInformation("Attempting to create location: {@LocationDto}", locationDto);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for location creation: {@ModelState}", ModelState);
                    return BadRequest(ModelState);
                }

                // Check if city exists
                var cityExists = await _context.Cities.AnyAsync(c => c.Id == locationDto.CityId);
                if (!cityExists)
                {
                    return BadRequest($"City with ID {locationDto.CityId} does not exist");
                }

                var location = new Location
                {
                    Name = locationDto.Name,
                    Address = locationDto.Address,
                    Latitude = locationDto.Latitude,
                    Longitude = locationDto.Longitude,
                    CityId = locationDto.CityId,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                
                _context.Locations.Add(location);
                await _context.SaveChangesAsync();

                // Return the location with related data
                var createdLocation = await _context.Locations
                    .Include(l => l.City)
                    .ThenInclude(c => c.Province)
                    .ThenInclude(p => p.Country)
                    .FirstOrDefaultAsync(l => l.Id == location.Id);

                return CreatedAtAction(nameof(GetLocation), new { id = location.Id }, createdLocation);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating location: {@LocationDto}", locationDto);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutLocation(int id, LocationDto locationDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var existingLocation = await _context.Locations.FindAsync(id);
                if (existingLocation == null)
                {
                    return NotFound();
                }

                // Update fields
                existingLocation.Name = locationDto.Name;
                existingLocation.Address = locationDto.Address;
                existingLocation.Latitude = locationDto.Latitude;
                existingLocation.Longitude = locationDto.Longitude;
                existingLocation.CityId = locationDto.CityId;
                existingLocation.UpdatedAt = DateTime.UtcNow;

                await _context.SaveChangesAsync();
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating location {LocationId}", id);
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLocation(int id)
        {
            try
            {
                var location = await _context.Locations.FindAsync(id);
                if (location == null)
                {
                    return NotFound();
                }

                _context.Locations.Remove(location);
                await _context.SaveChangesAsync();

                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting location {LocationId}", id);
                return StatusCode(500, "Internal server error");
            }
        }
    }
}
