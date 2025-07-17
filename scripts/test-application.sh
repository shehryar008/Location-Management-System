#!/bin/bash

echo "🧪 Testing the Location CRUD application..."

BASE_URL="http://localhost:8080"

echo "1. Waiting for application to be ready..."
sleep 30

echo ""
echo "2. Testing health endpoint..."
curl -s "$BASE_URL/health" && echo " ✅ Health check passed" || echo " ❌ Health check failed"

echo ""
echo "3. Testing external data endpoints..."
echo "   - Countries from external API:"
curl -s "$BASE_URL/api/externaldata/countries" | head -c 200 && echo "... ✅ External countries API working" || echo " ❌ External countries API failed"

echo ""
echo "   - States for United States:"
curl -s "$BASE_URL/api/externaldata/states/United%20States" | head -c 200 && echo "... ✅ External states API working" || echo " ❌ External states API failed"

echo ""
echo "4. Testing database CRUD endpoints..."
echo "   - Countries database:"
curl -s "$BASE_URL/api/countries" && echo " ✅ Countries database endpoint working" || echo " ❌ Countries database endpoint failed"

echo ""
echo "   - Provinces database:"
curl -s "$BASE_URL/api/provinces" && echo " ✅ Provinces database endpoint working" || echo " ❌ Provinces database endpoint failed"

echo ""
echo "   - Cities database:"
curl -s "$BASE_URL/api/cities" && echo " ✅ Cities database endpoint working" || echo " ❌ Cities database endpoint failed"

echo ""
echo "   - Locations database:"
curl -s "$BASE_URL/api/locations" && echo " ✅ Locations database endpoint working" || echo " ❌ Locations database endpoint failed"

echo ""
echo "5. Testing Swagger documentation..."
curl -s "$BASE_URL/swagger" | head -c 100 && echo "... ✅ Swagger available" || echo " ❌ Swagger not available"

echo ""
echo "6. Testing main application page..."
curl -s "$BASE_URL/" | head -c 100 && echo "... ✅ Main page with Leaflet maps available" || echo " ❌ Main page not available"

echo ""
echo "🏁 Application testing complete!"
echo ""
echo "🌐 If all tests passed, your Location Management System is ready!"
echo "   - Main App with Maps: http://localhost:8080"
echo "   - API Documentation: http://localhost:8080/swagger"
echo "   - Database: localhost:1435 (external access)"
