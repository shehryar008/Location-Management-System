#!/bin/bash

echo "🧹 Cleaning and rebuilding Docker containers..."

# Stop and remove all containers
echo "🛑 Stopping containers..."
docker-compose down --remove-orphans

# Remove dangling images and containers
echo "🗑️ Cleaning Docker system..."
docker system prune -f

# Remove application image to force rebuild
echo "🔨 Removing old application image..."
docker rmi locationcrud-app_locationcrud-app 2>/dev/null || true
docker rmi location-crud-app_locationcrud-app 2>/dev/null || true

# Fix namespaces
echo "🔧 Fixing namespaces..."
./scripts/fix-namespaces.sh

# Build with no cache
echo "🏗️ Building application (no cache)..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 30

# Check status
echo "📊 Service status:"
docker-compose ps

# Show recent logs
echo "📋 Recent logs:"
docker-compose logs --tail=30

echo "✅ Clean rebuild complete!"
echo ""
echo "🌐 Application should be available at:"
echo "   - Main App: http://localhost:8080"
echo "   - Swagger: http://localhost:8080/swagger"
echo "   - Health: http://localhost:8080/health"
