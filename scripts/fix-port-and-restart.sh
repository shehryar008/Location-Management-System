#!/bin/bash

echo "🔧 Fixing port conflict and restarting services..."

# Stop all containers
echo "🛑 Stopping all containers..."
docker-compose down --remove-orphans

# Wait a moment
sleep 5

# Start services with new port configuration
echo "🚀 Starting services with port 1435..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 45

# Check status
echo "📊 Service status:"
docker-compose ps

# Show logs
echo "📋 Recent logs:"
docker-compose logs --tail=30

echo ""
echo "✅ Services restarted with new port configuration!"
echo ""
echo "🌐 Application URLs:"
echo "   - Main App: http://localhost:8080"
echo "   - Swagger: http://localhost:8080/swagger"
echo "   - Health: http://localhost:8080/health"
echo ""
echo "🗄️ Database Connection (External):"
echo "   - Server: localhost,1435"
echo "   - Database: LocationManagerDb"
echo "   - Username: sa"
echo "   - Password: YourStrong@Password123"
echo ""
echo "📝 Note: The application connects to SQL Server internally on port 1433"
echo "         External connections use port 1435 to avoid Windows port conflicts"
