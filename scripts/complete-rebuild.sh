#!/bin/bash

echo "🚀 Complete rebuild with all fixes..."

# Stop everything
echo "🛑 Stopping all containers..."
docker-compose down --remove-orphans

# Clean Docker system
echo "🧹 Cleaning Docker system..."
docker system prune -f

# Remove any existing images
echo "🗑️ Removing old images..."
docker rmi $(docker images -q --filter "reference=*locationcrud*") 2>/dev/null || true

# Fix namespaces
echo "🔧 Fixing namespaces..."
chmod +x scripts/fix-all-namespaces.sh
./scripts/fix-all-namespaces.sh

# Build with no cache
echo "🏗️ Building application..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 45

# Check status
echo "📊 Service status:"
docker-compose ps

# Show logs
echo "📋 Recent logs:"
docker-compose logs --tail=50

echo ""
echo "✅ Complete rebuild finished!"
echo ""
echo "🌐 Application URLs:"
echo "   - Main App: http://localhost:8080"
echo "   - Swagger: http://localhost:8080/swagger"
echo "   - Health: http://localhost:8080/health"
echo ""
echo "🗄️ Database:"
echo "   - Server: localhost:1433"
echo "   - Database: LocationManagerDb"
echo "   - Username: sa"
echo "   - Password: YourStrong@Password123"
