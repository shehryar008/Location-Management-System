#!/bin/bash

echo "🚀 Performing a final clean rebuild with explicit Kestrel configuration and DTO fixes..."

# Stop and remove all containers
echo "🛑 Stopping all containers..."
docker-compose down --remove-orphans

# Clean Docker system
echo "🧹 Cleaning Docker system (removing dangling images and volumes)..."
docker system prune -f --volumes
docker volume prune -f # Aggressive volume prune to ensure no stale data/configs

# Remove any existing images related to the app
echo "🗑️ Removing old application images..."
docker rmi $(docker images -q --filter "reference=*locationcrud*") 2>/dev/null || true

# Build with no cache
echo "🏗️ Building application from scratch (no cache)..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting services..."
# Explicitly use both docker-compose.yml and docker-compose.override.yml
# This ensures the override takes effect for development
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

# Wait for services
echo "⏳ Waiting for services to start (this might take a minute)..."
sleep 60

# Check status
echo "📊 Service status:"
docker-compose ps

# Show logs
echo "📋 Recent logs from application container:"
docker-compose logs locationcrud-app --tail=50

echo ""
echo "✅ Final clean rebuild complete!"
echo ""
echo "🌐 Application URLs:"
echo "   - Main App (Development): http://localhost:5000" # Now only HTTP
echo "   - Main App (Production/Docker): http://localhost:8080"
echo "   - Swagger: http://localhost:8080/swagger"
echo "   - Health: http://localhost:8080/health"
echo ""
echo "🗄️ Database Connection (External):"
echo "   - Development: localhost,6434"
echo "   - Production/Docker: localhost,5433" # This is the port from alternative-ports.sh
echo "   - Database: LocationManagerDb"
echo "   - Username: sa"
# Ensure this password matches your docker-compose.yml SA_PASSWORD
echo "   - Password: YourStrong@Password123" 
echo ""
echo "🧪 Next: Run the test scripts to verify functionality!"
