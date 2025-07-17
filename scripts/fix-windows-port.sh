#!/bin/bash

echo "🔧 Fixing Windows port restrictions..."

# Stop all containers
echo "🛑 Stopping all containers..."
docker-compose down --remove-orphans

# Check what ports are restricted on Windows
echo "🔍 Checking Windows port restrictions..."
echo "Common restricted ports on Windows: 1433, 1434, 1435, 1436"
echo "Using port 5433 instead..."

# Clean up any existing containers
echo "🧹 Cleaning up..."
docker system prune -f

# Start services with new port
echo "🚀 Starting services with port 5433..."
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 45

# Check status
echo "📊 Service status:"
docker-compose ps

# Show logs
echo "📋 Recent logs:"
docker-compose logs --tail=30

echo ""
echo "✅ Services started with Windows-compatible ports!"
echo ""
echo "🌐 Application URLs:"
echo "   - Main App: http://localhost:8080"
echo "   - Swagger: http://localhost:8080/swagger"
echo "   - Health: http://localhost:8080/health"
echo ""
echo "🗄️ Database Connection (External):"
echo "   - Server: localhost,5433"
echo "   - Database: LocationManagerDb"
echo "   - Username: sa"
echo "   - Password: YourStrong@Password123"
