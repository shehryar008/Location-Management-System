#!/bin/bash

echo "🔄 Trying alternative port configuration..."

# Stop containers
docker-compose down --remove-orphans

# Create temporary docker-compose with different ports
cat > docker-compose.temp.yml << 'EOF'
services:
  # SQL Server Database
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: locationcrud-sqlserver
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=YourStrong@Password123
      - MSSQL_PID=Express
    ports:
      - "6433:1433"  # Using port 6433 instead
    volumes:
      - sqlserver_data:/var/opt/mssql
    networks:
      - locationcrud-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Password123 -C -Q 'SELECT 1'"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 30s

  # Location CRUD Application
  locationcrud-app:
    build: .
    container_name: locationcrud-app
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__DefaultConnection=Server=sqlserver,1433;Database=LocationManagerDb;User Id=sa;Password=YourStrong@Password123;TrustServerCertificate=true;MultipleActiveResultSets=true
    ports:
      - "8080:80"
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - locationcrud-network
    restart: unless-stopped
    volumes:
      - app_logs:/app/logs

  # Database Initialization Service
  db-init:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: locationcrud-db-init
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=YourStrong@Password123
    volumes:
      - ./scripts:/scripts
    networks:
      - locationcrud-network
    depends_on:
      sqlserver:
        condition: service_healthy
    command: >
      bash -c "
        echo 'Waiting for SQL Server to be ready...'
        sleep 30
        echo 'Running database initialization scripts...'
        /opt/mssql-tools18/bin/sqlcmd -S sqlserver -U sa -P YourStrong@Password123 -C -i /scripts/create-database.sql
        /opt/mssql-tools18/bin/sqlcmd -S sqlserver -U sa -P YourStrong@Password123 -C -i /scripts/seed-data.sql
        echo 'Database initialization completed!'
      "
    restart: "no"

volumes:
  sqlserver_data:
    driver: local
  app_logs:
    driver: local

networks:
  locationcrud-network:
    driver: bridge
EOF

echo "🚀 Starting with port 6433..."
docker-compose -f docker-compose.temp.yml up -d

sleep 30

echo "📊 Checking status..."
docker-compose -f docker-compose.temp.yml ps

if [ $? -eq 0 ]; then
    echo "✅ Success! Port 6433 works. Updating main docker-compose.yml..."
    cp docker-compose.temp.yml docker-compose.yml
    rm docker-compose.temp.yml
    echo "🌐 Database now available at: localhost:6433"
else
    echo "❌ Port 6433 also failed. Trying port 7433..."
    docker-compose -f docker-compose.temp.yml down
    
    # Try port 7433
    sed -i 's/6433:1433/7433:1433/g' docker-compose.temp.yml
    docker-compose -f docker-compose.temp.yml up -d
    
    sleep 30
    
    if docker-compose -f docker-compose.temp.yml ps | grep -q "Up"; then
        echo "✅ Success! Port 7433 works."
        cp docker-compose.temp.yml docker-compose.yml
        echo "🌐 Database now available at: localhost:7433"
    else
        echo "❌ Multiple ports failed. This might be a Windows/Hyper-V issue."
        echo "💡 Try running as Administrator or disabling Hyper-V temporarily."
    fi
    
    rm docker-compose.temp.yml
fi
