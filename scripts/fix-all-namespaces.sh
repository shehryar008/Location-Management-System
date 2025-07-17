#!/bin/bash

echo "🔧 Fixing all namespace inconsistencies..."

# Fix Controllers that use LocationManager namespace
echo "Fixing Controllers..."
sed -i 's/namespace LocationManager\./namespace LocationCRUD\./g' Controllers/LocationController.cs
sed -i 's/using LocationManager\./using LocationCRUD\./g' Controllers/LocationController.cs

sed -i 's/namespace LocationManager\./namespace LocationCRUD\./g' Controllers/CountryController.cs
sed -i 's/using LocationManager\./using LocationCRUD\./g' Controllers/CountryController.cs

sed -i 's/namespace LocationManager\./namespace LocationCRUD\./g' Controllers/ProvinceController.cs
sed -i 's/using LocationManager\./using LocationCRUD\./g' Controllers/ProvinceController.cs

sed -i 's/namespace LocationManager\./namespace LocationCRUD\./g' Controllers/CityController.cs
sed -i 's/using LocationManager\./using LocationCRUD\./g' Controllers/CityController.cs

echo "✅ All namespace fixes applied!"
