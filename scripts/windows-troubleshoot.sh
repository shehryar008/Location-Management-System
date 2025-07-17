#!/bin/bash

echo "🔍 Windows Docker troubleshooting guide..."

echo ""
echo "🚨 Common Windows Docker issues and solutions:"
echo ""

echo "1. 📋 Port Range Issues:"
echo "   - Windows reserves ports 1433-1434 for SQL Server"
echo "   - Hyper-V reserves dynamic port ranges"
echo "   - Solution: Use ports 5433, 6433, or 7433"

echo ""
echo "2. 🔒 Hyper-V Port Exclusions:"
echo "   - Check excluded ports: netsh int ipv4 show excludedportrange protocol=tcp"
echo "   - Solution: Use ports outside excluded ranges"

echo ""
echo "3. 🛡️ Windows Defender/Firewall:"
echo "   - May block Docker port bindings"
echo "   - Solution: Add Docker Desktop to firewall exceptions"

echo ""
echo "4. 👤 Administrator Privileges:"
echo "   - Some port operations require admin rights"
echo "   - Solution: Run PowerShell/Command Prompt as Administrator"

echo ""
echo "🔧 Quick fixes to try:"
echo ""

echo "Option A - Use different port:"
echo "   ./scripts/alternative-ports.sh"

echo ""
echo "Option B - Reset Docker:"
echo "   docker system prune -a"
echo "   Restart Docker Desktop"

echo ""
echo "Option C - Check Windows services:"
echo "   services.msc -> Stop 'SQL Server' services if running"

echo ""
echo "Option D - Disable Hyper-V temporarily (requires restart):"
echo "   dism.exe /Online /Disable-Feature:Microsoft-Hyper-V"
echo "   (Re-enable later: dism.exe /Online /Enable-Feature:Microsoft-Hyper-V)"

echo ""
echo "🎯 Recommended immediate action:"
echo "   Run: ./scripts/alternative-ports.sh"
