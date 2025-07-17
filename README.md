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
- **SQL Server**: Persistent data storage using SQL Server, managed via Docker.
- **Entity Framework Core**: Full ORM support for database interactions.
- **Seed Data**: Sample data automatically loaded into the database on initialization.

## Technology Stack

- **.NET 8.0**: Latest .NET framework for the backend API.
- **ASP.NET Core Web API**: RESTful API architecture.
- **Entity Framework Core**: Object-relational mapping.
- **SQL Server**: Relational database for data persistence.
- **Tailwind CSS**: Utility-first CSS framework for styling.
- **shadcn/ui**: Reusable UI components built with Tailwind CSS.
- **Leaflet.js**: Interactive mapping library.
- **OpenStreetMap**: Free map tiles.

## Getting Started

### Prerequisites

- **Docker Desktop**: Required to run the application and SQL Server in containers.
- **.NET 8.0 SDK or later**: For local development and building the .NET application.

### Installation

1.  **Clone the repository**
    \`\`\`bash
    git clone <repository-url>
    cd location-crud-app
    \`\`\`

2.  **Build and start Docker services**
    This command will build the .NET application image, set up the SQL Server container, and run the database initialization scripts.
    \`\`\`bash
    docker-compose up --build -d
    \`\`\`
    *   The `db-init` service will automatically create the `LocationManagerDb` database and seed it with initial data.
    *   The `locationcrud-app` service will be available on `http://localhost:5000` 

3.  **Install frontend dependencies**
    Navigate to the `app` directory (where `package.json` for the Next.js app is located) and install dependencies:
    \`\`\`bash
    cd app
    npm install # or yarn install
    \`\`\`

### Access the Application

Once Docker services are up and running:

-   **Main Application (Development)**: Open your browser and navigate to `http://localhost:5000`
-   **Main Application (Production/Docker)**: Open your browser and navigate to `http://localhost:8080`
-   **Swagger API Documentation**: `http://localhost:8080/swagger`
-   **Health Check**: `http://localhost:8080/health`

## Acknowledgments

-   **OpenStreetMap**: For providing free map tiles.
-   **Leaflet.js**: For the excellent mapping library.
-   **countriesnow.space**: For the countries/states/cities API.
-   **Next.js**: For the powerful React framework.
-   **Tailwind CSS & shadcn/ui**: For modern and efficient UI development.
