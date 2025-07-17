#!/bin/bash

echo "🔧 Fixing Docker issues and rebuilding..."

# Stop and remove all containers
echo "🛑 Stopping all containers..."
docker-compose down --remove-orphans

# Remove any dangling images
echo "🧹 Cleaning up Docker images..."
docker system prune -f

# Remove existing volumes (optional - only if you want fresh data)
# docker volume rm location-crud-app_sqlserver_data location-crud-app_app_logs

# Build with no cache
echo "🔨 Building application..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 30

# Check status
echo "📊 Checking service status..."
docker-compose ps

# Show logs
echo "📋 Recent logs:"
docker-compose logs --tail=20

echo "✅ Rebuild complete!"
