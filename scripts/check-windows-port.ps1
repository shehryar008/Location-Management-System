
Write-Host "🔍 Checking Windows port restrictions..." -ForegroundColor Cyan

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "⚠️ Not running as Administrator. Some port checks may be limited." -ForegroundColor Yellow
}

Write-Host "📋 Checking Windows reserved port ranges..." -ForegroundColor Green

try {
    # Get excluded port ranges (requires admin)
    if ($isAdmin) {
        $excludedPorts = netsh int ipv4 show excludedportrange protocol=tcp
        Write-Host "Windows excluded port ranges:" -ForegroundColor Yellow
        Write-Host $excludedPorts
    }
} catch {
    Write-Host "Could not check excluded ports (requires admin privileges)" -ForegroundColor Yellow
}

# Test specific ports
$portsToTest = @(1433, 1434, 1435, 1436, 5433, 5434)

Write-Host ""
Write-Host "🔍 Testing port availability..." -ForegroundColor Green

foreach ($port in $portsToTest) {
    try {
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
        $listener.Start()
        $listener.Stop()
        Write-Host "✅ Port $port is available" -ForegroundColor Green
    } catch {
        Write-Host "❌ Port $port is NOT available" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🔧 Recommended actions:" -ForegroundColor Cyan
Write-Host "1. Use port 5433 for SQL Server (should be available)" -ForegroundColor White
Write-Host "2. Run: docker-compose down --remove-orphans" -ForegroundColor White
Write-Host "3. Run: docker-compose up -d" -ForegroundColor White

Write-Host ""
Write-Host "💡 If ports are still blocked, try:" -ForegroundColor Yellow
Write-Host "   - Run PowerShell as Administrator" -ForegroundColor White
Write-Host "   - Disable Hyper-V temporarily: dism.exe /Online /Disable-Feature:Microsoft-Hyper-V" -ForegroundColor White
Write-Host "   - Use different port range (6000-7000)" -ForegroundColor White
