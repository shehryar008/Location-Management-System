#!/bin/bash

echo "🚀 Final rebuild with all fixes..."

# Stop everything
echo "🛑 Stopping all containers..."
docker-compose down --remove-orphans

# Clean Docker system
echo "🧹 Cleaning Docker system..."
docker system prune -f

# Remove any existing images
echo "🗑️ Removing old images..."
docker rmi $(docker images -q --filter "reference=*locationcrud*") 2>/dev/null || true

# Fix duplicate models
echo "🔧 Fixing duplicate models..."
chmod +x scripts/fix-duplicate-models.sh
./scripts/fix-duplicate-models.sh

# Build with no cache
echo "🏗️ Building application..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 60

# Check status
echo "📊 Service status:"
docker-compose ps

# Show logs
echo "📋 Recent logs:"
docker-compose logs --tail=50

echo ""
echo "✅ Final rebuild complete!"
echo ""
echo "🌐 Application URLs:"
echo "   - Main App: http://localhost:8080"
echo "   - Swagger: http://localhost:8080/swagger"
echo "   - Health: http://localhost:8080/health"
echo ""
echo "🧪 Test endpoints:"
echo "   curl http://localhost:8080/health"
echo "   curl http://localhost:8080/api/externaldata/countries"
echo "   curl http://localhost:8080/api/countries"
