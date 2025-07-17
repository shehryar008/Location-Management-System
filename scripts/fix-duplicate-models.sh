#!/bin/bash

echo "🔧 Fixing duplicate model definitions..."

# Remove individual model files if they exist
rm -f Models/Country.cs
rm -f Models/Province.cs  
rm -f Models/City.cs
rm -f Models/Location.cs

# Keep only the consolidated LocationModels.cs and DTOs.cs
echo "✅ Removed duplicate model files"

# List remaining files in Models directory
echo "📁 Remaining files in Models directory:"
ls -la Models/

echo "✅ Model cleanup complete!"
