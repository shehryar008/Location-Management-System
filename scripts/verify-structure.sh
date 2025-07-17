#!/bin/bash

echo "🔍 Verifying project structure..."

echo ""
echo "📁 Project structure:"
find . -name "*.cs" -not -path "./bin/*" -not -path "./obj/*" | sort

echo ""
echo "📋 Models directory contents:"
ls -la Models/

echo ""
echo "📋 Controllers directory contents:"
ls -la Controllers/

echo ""
echo "🔍 Checking for duplicate definitions..."
echo "Searching for 'class Country':"
grep -r "class Country" --include="*.cs" . | grep -v bin | grep -v obj

echo ""
echo "Searching for 'class Province':"
grep -r "class Province" --include="*.cs" . | grep -v bin | grep -v obj

echo ""
echo "Searching for 'class City':"
grep -r "class City" --include="*.cs" . | grep -v bin | grep -v obj

echo ""
echo "Searching for 'class Location':"
grep -r "class Location" --include="*.cs" . | grep -v bin | grep -v obj

echo ""
echo "✅ Structure verification complete!"
