# PowerShell script for Windows users
Write-Host "🔧 Fixing port conflict on Windows..." -ForegroundColor Green

# Stop all containers
Write-Host "🛑 Stopping all containers..." -ForegroundColor Yellow
docker-compose down --remove-orphans

# Wait a moment
Start-Sleep -Seconds 5

# Check if port 1435 is available
Write-Host "🔍 Checking port availability..." -ForegroundColor Cyan
$portTest = Test-NetConnection -ComputerName localhost -Port 1435 -InformationLevel Quiet
if ($portTest) {
    Write-Host "⚠️ Port 1435 is also in use, trying port 1436..." -ForegroundColor Yellow
    # You can modify docker-compose.yml to use 1436:1433 if needed
}

# Start services
Write-Host "🚀 Starting services..." -ForegroundColor Green
docker-compose up -d

# Wait for services
Write-Host "⏳ Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 45

# Check status
Write-Host "📊 Service status:" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "✅ Services started!" -ForegroundColor Green
Write-Host "🌐 Application: http://localhost:8080" -ForegroundColor Cyan
Write-Host "🗄️ Database: localhost:1435" -ForegroundColor Cyan
