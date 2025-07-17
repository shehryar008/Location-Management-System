#!/bin/bash

echo "📝 Creating sample data via API..."

BASE_URL="http://localhost:8080"

echo "1. Creating sample country..."
curl -X POST "$BASE_URL/api/countries" \
  -H "Content-Type: application/json" \
  -d '{"name": "Pakistan", "code": "PK"}' && echo " ✅ Pakistan created"

echo ""
echo "2. Getting country ID..."
COUNTRY_RESPONSE=$(curl -s "$BASE_URL/api/countries")
echo "Countries in database: $COUNTRY_RESPONSE"

echo ""
echo "3. Creating sample province..."
curl -X POST "$BASE_URL/api/provinces" \
  -H "Content-Type: application/json" \
  -d '{"name": "Punjab", "code": "PB", "countryId": 1}' && echo " ✅ Punjab created"

echo ""
echo "4. Creating sample city..."
curl -X POST "$BASE_URL/api/cities" \
  -H "Content-Type: application/json" \
  -d '{"name": "Gujranwala", "code": "GRW", "provinceId": 1}' && echo " ✅ Gujranwala created"

echo ""
echo "5. Creating sample location with coordinates..."
curl -X POST "$BASE_URL/api/locations" \
  -H "Content-Type: application/json" \
  -d '{"name": "Main Office", "address": "GT Road, Gujranwala", "latitude": 32.1877, "longitude": 74.1945, "cityId": 1}' && echo " ✅ Location created"

echo ""
echo "6. Verifying created data..."
echo "   - Countries:"
curl -s "$BASE_URL/api/countries" | head -c 200 && echo "..."

echo ""
echo "   - Locations:"
curl -s "$BASE_URL/api/locations" | head -c 300 && echo "..."

echo ""
echo "✅ Sample data creation complete!"
echo "🗺️ You should now see the location on the map at http://localhost:8080"
