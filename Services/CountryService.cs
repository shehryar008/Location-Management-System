using System.Text.Json;

namespace LocationCRUD.Services
{
    public class CountryService
    {
        private readonly HttpClient _httpClient;
        private readonly ILogger<CountryService> _logger;

        public CountryService(HttpClient httpClient, ILogger<CountryService> logger)
        {
            _httpClient = httpClient;
            _logger = logger;
        }

        public async Task<List<CountryApiResponse>> GetCountriesAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync("https://countriesnow.space/api/v0.1/countries");
                response.EnsureSuccessStatusCode();
                
                var json = await response.Content.ReadAsStringAsync();
                var apiResponse = JsonSerializer.Deserialize<CountriesApiWrapper>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                return apiResponse?.Data ?? new List<CountryApiResponse>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching countries from API");
                return new List<CountryApiResponse>();
            }
        }

        public async Task<List<StateApiResponse>> GetStatesAsync(string country)
        {
            try
            {
                var requestBody = new { country = country };
                var json = JsonSerializer.Serialize(requestBody);
                var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

                var response = await _httpClient.PostAsync("https://countriesnow.space/api/v0.1/countries/states", content);
                response.EnsureSuccessStatusCode();
                
                var responseJson = await response.Content.ReadAsStringAsync();
                var apiResponse = JsonSerializer.Deserialize<StatesApiWrapper>(responseJson, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                return apiResponse?.Data?.States ?? new List<StateApiResponse>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching states for country {Country}", country);
                return new List<StateApiResponse>();
            }
        }

        public async Task<List<string>> GetCitiesAsync(string country, string state)
        {
            try
            {
                var requestBody = new { country = country, state = state };
                var json = JsonSerializer.Serialize(requestBody);
                var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

                var response = await _httpClient.PostAsync("https://countriesnow.space/api/v0.1/countries/state/cities", content);
                response.EnsureSuccessStatusCode();
                
                var responseJson = await response.Content.ReadAsStringAsync();
                var apiResponse = JsonSerializer.Deserialize<CitiesApiWrapper>(responseJson, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                return apiResponse?.Data ?? new List<string>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching cities for country {Country}, state {State}", country, state);
                return new List<string>();
            }
        }
    }

    // API Response Models
    public class CountriesApiWrapper
    {
        public bool Error { get; set; }
        public string Msg { get; set; } = string.Empty;
        public List<CountryApiResponse> Data { get; set; } = new();
    }

    public class CountryApiResponse
    {
        public string Country { get; set; } = string.Empty;
        public List<string> Cities { get; set; } = new();
    }

    public class StatesApiWrapper
    {
        public bool Error { get; set; }
        public string Msg { get; set; } = string.Empty;
        public StatesData Data { get; set; } = new();
    }

    public class StatesData
    {
        public string Name { get; set; } = string.Empty;
        public string Iso3 { get; set; } = string.Empty;
        public List<StateApiResponse> States { get; set; } = new();
    }

    public class StateApiResponse
    {
        public string Name { get; set; } = string.Empty;
        public string State_Code { get; set; } = string.Empty;
    }

    public class CitiesApiWrapper
    {
        public bool Error { get; set; }
        public string Msg { get; set; } = string.Empty;
        public List<string> Data { get; set; } = new();
    }
}
