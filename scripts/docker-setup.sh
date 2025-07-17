#!/bin/bash

# Docker setup script for Location CRUD Application

echo "🚀 Setting up Location CRUD Application with Docker..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p logs
mkdir -p data

# Set permissions
chmod +x scripts/*.sh

# Build and start services
echo "🔨 Building and starting services..."
docker-compose down --remove-orphans
docker-compose build --no-cache
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🔍 Checking service health..."
docker-compose ps

# Show logs
echo "📋 Showing recent logs..."
docker-compose logs --tail=20

echo "✅ Setup complete!"
echo ""
echo "🌐 Application URLs:"
echo "   - Application: http://localhost:8080"
echo "   - Swagger API: http://localhost:8080/swagger"
echo "   - Health Check: http://localhost:8080/health"
echo ""
echo "🗄️  Database Connection:"
echo "   - Server: localhost,1433"
echo "   - Database: LocationManagerDb"
echo "   - Username: sa"
echo "   - Password: 123456"
echo ""
echo "📊 Useful Commands:"
echo "   - View logs: docker-compose logs -f"
echo "   - Stop services: docker-compose down"
echo "   - Restart services: docker-compose restart"
echo "   - View volumes: docker volume ls"
echo "   - Backup database: ./scripts/backup-database.sh"
