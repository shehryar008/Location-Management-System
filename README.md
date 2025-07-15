# Location Management System

A comprehensive .NET Core Web API application for managing hierarchical location data (Countries → Provinces/States → Cities → Locations) with interactive mapping capabilities using Leaflet maps.

## Features

### 🌍 Hierarchical Location Management
- **Countries**: Manage country data with external API integration
- **Provinces/States**: Province and state management linked to countries
- **Cities**: City management linked to provinces
- **Locations**: Specific locations with coordinates and addresses

### 🗺️ Interactive Mapping
- **Leaflet Maps Integration**: Open-source mapping with OpenStreetMap tiles
- **Click-to-Set Coordinates**: Click anywhere on the map to set location coordinates
- **Auto-Geocoding**: Automatic coordinate lookup using Nominatim (OpenStreetMap)
- **Visual Markers**: 
  - Blue markers for selected/current locations
  - Red markers for saved locations
- **Interactive Popups**: Click markers to view details and perform actions

### 🔄 External API Integration
- **Real-time Data**: Fetches countries, provinces, and cities from countriesnow.space API
- **Cascading Dropdowns**: Dynamic loading of provinces based on country selection
- **Auto-population**: Automatically creates database entries for selected locations

### 💾 Database Support
- **In-Memory Database**: For development and testing
- **SQL Server Support**: Ready for production with LocalDB/SQL Server
- **Entity Framework Core**: Full ORM support with migrations
- **Seed Data**: Sample data for quick testing

## Technology Stack

- **.NET 9.0**: Latest .NET framework
- **ASP.NET Core Web API**: RESTful API architecture
- **Entity Framework Core**: Object-relational mapping
- **SQL Server/In-Memory Database**: Data persistence
- **Leaflet.js**: Interactive mapping
- **OpenStreetMap**: Free map tiles
- **Bootstrap 5**: Responsive UI framework
- **Vanilla JavaScript**: Frontend interactions

## Getting Started

### Prerequisites

- .NET 9.0 SDK or later
- Visual Studio 2022 or VS Code
- SQL Server LocalDB (optional, uses in-memory database by default)

### Installation

1. **Clone the repository**
   \`\`\`bash
   git clone <repository-url>
   cd location-crud-app
   \`\`\`

2. **Restore packages**
   \`\`\`bash
   dotnet restore
   \`\`\`

3. **Run the application**
   \`\`\`bash
   dotnet run
   \`\`\`

4. **Access the application**
   - Open your browser and navigate to \`https://localhost:5001\` or \`http://localhost:5000\`
   - The application will automatically create the in-memory database

### Database Setup (Optional)

To use SQL Server instead of in-memory database:

1. **Update connection string** in \`appsettings.json\`:
   \`\`\`json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=LocationManagerDb;Trusted_Connection=true;MultipleActiveResultSets=true"
     }
   }
   \`\`\`

2. **Update Program.cs** to use SQL Server:
   \`\`\`csharp
   builder.Services.AddDbContext<ApplicationDbContext>(options =>
       options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
   \`\`\`

3. **Run database scripts** (optional):
   - Execute \`scripts/create-database.sql\` to create tables
   - Execute \`scripts/seed-data.sql\` to add sample data


## Usage Guide

### Adding a New Location

1. **Select Country**: Choose from the dropdown (data fetched from external API)
2. **Select Province/State**: Automatically populated based on country selection
3. **Select City**: Automatically populated based on province selection
4. **Enter Location Details**:
   - Location name (required)
   - Address (optional)
5. **Set Coordinates**:
   - Click "Get Coordinates from Address" for automatic geocoding
   - Or click directly on the map to set coordinates manually
6. **Save Location**: Click "Save Location" to create the entry

### Map Interactions

- **Blue Markers**: Show your current selection or location being edited
- **Red Markers**: Show all saved locations from the database
- **Click Map**: Set coordinates by clicking anywhere on the map
- **Click Markers**: View location details and access edit/delete options
- **Map Controls**:
  - "Show All Locations": Fit map to display all saved locations
  - "Clear Selection": Remove temporary markers and coordinates

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **OpenStreetMap**: For providing free map tiles
- **Leaflet.js**: For the excellent mapping library
- **countriesnow.space**: For the countries/states/cities API
- **Bootstrap**: For the responsive UI framework
