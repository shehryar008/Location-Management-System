using Microsoft.AspNetCore.Mvc;
using LocationCRUD.Services;

namespace LocationCRUD.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ExternalDataController : ControllerBase
    {
        private readonly CountryService _countryService;

        public ExternalDataController(CountryService countryService)
        {
            _countryService = countryService;
        }

        [HttpGet("countries")]
        public async Task<ActionResult<IEnumerable<object>>> GetCountries()
        {
            var countries = await _countryService.GetCountriesAsync();
            var result = countries.Select((country, index) => new
            {
                Id = index + 1,
                Name = country.Country
            }).ToList();

            return Ok(result);
        }

        [HttpGet("states/{country}")]
        public async Task<ActionResult<IEnumerable<object>>> GetStates(string country)
        {
            var states = await _countryService.GetStatesAsync(country);
            var result = states.Select((state, index) => new
            {
                Id = index + 1,
                Name = state.Name,
                Code = state.State_Code
            }).ToList();

            return Ok(result);
        }

        [HttpGet("cities/{country}/{state}")]
        public async Task<ActionResult<IEnumerable<object>>> GetCities(string country, string state)
        {
            var cities = await _countryService.GetCitiesAsync(country, state);
            var result = cities.Select((city, index) => new
            {
                Id = index + 1,
                Name = city
            }).ToList();

            return Ok(result);
        }
    }
}
