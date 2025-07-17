#!/bin/bash

echo "🧪 Testing API endpoints..."

BASE_URL="http://localhost:8080"

echo "1. Testing health endpoint..."
curl -s "$BASE_URL/health" && echo " ✅ Health check passed" || echo " ❌ Health check failed"

echo ""
echo "2. Testing external data endpoints..."
curl -s "$BASE_URL/api/externaldata/countries" | head -c 100 && echo "... ✅ Countries endpoint working" || echo " ❌ Countries endpoint failed"

echo ""
echo "3. Testing database endpoints..."
curl -s "$BASE_URL/api/countries" && echo " ✅ Countries database endpoint working" || echo " ❌ Countries database endpoint failed"

echo ""
echo "4. Testing Swagger..."
curl -s "$BASE_URL/swagger" | head -c 50 && echo "... ✅ Swagger available" || echo " ❌ Swagger not available"

echo ""
echo "🏁 Endpoint testing complete!"
