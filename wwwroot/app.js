const API_BASE = "/api"
const L = window.L 

let currentCountryName = ""
let currentProvinceName = ""

let map
let markers = []
let currentMarker = null

document.addEventListener("DOMContentLoaded", () => {
    loadCountries()
    loadLocations()
    setupEventListeners()
    initMap()
})

function setupEventListeners() {
    document.getElementById("countrySelect").addEventListener("change", onCountryChange)
    document.getElementById("provinceSelect").addEventListener("change", onProvinceChange)
    document.getElementById("locationForm").addEventListener("submit", onLocationSubmit)
}

function initMap() {
    map = L.map("map").setView([20, 0], 2)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "© OpenStreetMap contributors",
    }).addTo(map)
    map.on("click", (e) => {
        const lat = e.latlng.lat
        const lng = e.latlng.lng

        document.getElementById("latitude").value = lat.toFixed(6)
        document.getElementById("longitude").value = lng.toFixed(6)

        setCurrentMarker(lat, lng, "Selected Location")
    })

    setTimeout(loadLocationsOnMap, 1000)
}

function setCurrentMarker(lat, lng, title) {
    if (currentMarker) {
        map.removeLayer(currentMarker)
    }

    const blueIcon = L.icon({
        iconUrl: "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png",
        shadowUrl: "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41],
    })

    currentMarker = L.marker([lat, lng], { icon: blueIcon }).addTo(map).bindPopup(title).openPopup()
}

function clearTempMarkers() {
    if (currentMarker) {
        map.removeLayer(currentMarker)
        currentMarker = null
    }
    document.getElementById("latitude").value = ""
    document.getElementById("longitude").value = ""
}

function addLocationMarker(location) {
    if (!location.latitude || !location.longitude) return

    const redIcon = L.icon({
        iconUrl: "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png",
        shadowUrl: "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41],
    })

    const marker = L.marker([Number.parseFloat(location.latitude), Number.parseFloat(location.longitude)], {
        icon: redIcon,
    }).addTo(map)

    const popupContent = `
    <div class="location-info">
      <h6><strong>${location.name}</strong></h6>
      ${location.address ? `<p><strong>Address:</strong> ${location.address}</p>` : ""}
      <p><strong>City:</strong> ${location.city.name}</p>
      <p><strong>Province:</strong> ${location.city.province.name}</p>
      <p><strong>Country:</strong> ${location.city.province.country.name}</p>
      <p><strong>Coordinates:</strong> ${Number.parseFloat(location.latitude).toFixed(4)}, ${Number.parseFloat(location.longitude).toFixed(4)}</p>
      <button class="btn btn-sm btn-primary me-1" onclick="editLocation(${location.id})">Edit</button>
      <button class="btn btn-sm btn-danger me-1" onclick="deleteLocation(${location.id})">Delete</button>
    </div>
  `

    marker.bindPopup(popupContent)
    markers.push(marker)
}

function clearAllLocationMarkers() {
    markers.forEach((marker) => map.removeLayer(marker))
    markers = []
}

function fitAllMarkers() {
    if (markers.length > 0) {
        const group = new L.featureGroup(markers)
        map.fitBounds(group.getBounds().pad(0.1))
    }
}

async function loadLocationsOnMap() {
    try {
        const response = await fetch(`${API_BASE}/locations`)
        const locations = await response.json()

        clearAllLocationMarkers()

        if (locations.length > 0) {
            locations.forEach((location) => {
                addLocationMarker(location)
            })

            fitAllMarkers()
        }
    } catch (error) {
        console.error("Error loading locations on map:", error)
    }
}

async function geocodeLocation() {
    const countryName = document.getElementById("countrySelect").value
    const provinceName = document.getElementById("provinceSelect").value
    const cityName = document.getElementById("citySelect").value
    const address = document.getElementById("locationAddress").value

    if (!countryName || !provinceName || !cityName) {
        alert("Please select country, province, and city first")
        return
    }

    let addressString = ""
    if (address) {
        addressString = `${address}, `
    }
    addressString += `${cityName}, ${provinceName}, ${countryName}`

    console.log("Geocoding address:", addressString)

    try {
        const response = await fetch(
            `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(addressString)}&limit=1`,
        )
        const data = await response.json()

        if (data && data.length > 0) {
            const lat = Number.parseFloat(data[0].lat)
            const lng = Number.parseFloat(data[0].lon)

            document.getElementById("latitude").value = lat.toFixed(6)
            document.getElementById("longitude").value = lng.toFixed(6)

            // Center map on location and add marker
            map.setView([lat, lng], 13)
            setCurrentMarker(lat, lng, `${cityName}, ${provinceName}, ${countryName}`)

            console.log("Geocoding successful:", lat, lng)
        } else {
            console.error("Geocoding failed: No results found")
            alert(
                "Could not find coordinates for this location. Please try entering a more specific address or set coordinates manually by clicking on the map.",
            )
        }
    } catch (error) {
        console.error("Geocoding error:", error)
        alert("Error occurred while finding location coordinates.")
    }
}

async function loadCountries() {
    try {
        const response = await fetch(`${API_BASE}/externaldata/countries`)
        const countries = await response.json()

        const countrySelect = document.getElementById("countrySelect")
        countrySelect.innerHTML = '<option value="">Select Country</option>'

        countries.forEach((country) => {
            const option = document.createElement("option")
            option.value = country.name
            option.textContent = country.name
            countrySelect.appendChild(option)
        })
    } catch (error) {
        console.error("Error loading countries:", error)
        document.getElementById("countrySelect").innerHTML = '<option value="">Error loading countries</option>'
    }
}

async function onCountryChange() {
    const countryName = document.getElementById("countrySelect").value
    const provinceSelect = document.getElementById("provinceSelect")
    const citySelect = document.getElementById("citySelect")

    currentCountryName = countryName

    provinceSelect.innerHTML = '<option value="">Select Province</option>'
    citySelect.innerHTML = '<option value="">Select City</option>'
    provinceSelect.disabled = !countryName
    citySelect.disabled = true

    if (countryName) {
        provinceSelect.innerHTML = '<option value="">Loading provinces...</option>'

        try {
            const response = await fetch(`${API_BASE}/externaldata/states/${encodeURIComponent(countryName)}`)
            const provinces = await response.json()

            provinceSelect.innerHTML = '<option value="">Select Province</option>'
            provinces.forEach((province) => {
                const option = document.createElement("option")
                option.value = province.name
                option.textContent = province.name
                provinceSelect.appendChild(option)
            })
        } catch (error) {
            console.error("Error loading provinces:", error)
            provinceSelect.innerHTML = '<option value="">Error loading provinces</option>'
        }
    }
}

async function onProvinceChange() {
    const provinceName = document.getElementById("provinceSelect").value
    const citySelect = document.getElementById("citySelect")

    currentProvinceName = provinceName

    // Reset city dropdown
    citySelect.innerHTML = '<option value="">Select City</option>'
    citySelect.disabled = !provinceName

    if (provinceName && currentCountryName) {
        citySelect.innerHTML = '<option value="">Loading cities...</option>'

        try {
            const response = await fetch(
                `${API_BASE}/externaldata/cities/${encodeURIComponent(currentCountryName)}/${encodeURIComponent(provinceName)}`,
            )
            const cities = await response.json()

            citySelect.innerHTML = '<option value="">Select City</option>'
            cities.forEach((city) => {
                const option = document.createElement("option")
                option.value = city.name
                option.textContent = city.name
                citySelect.appendChild(option)
            })
        } catch (error) {
            console.error("Error loading cities:", error)
            citySelect.innerHTML = '<option value="">Error loading cities</option>'
        }
    }
}

async function onLocationSubmit(event) {
    event.preventDefault()

    const countryName = document.getElementById("countrySelect").value
    const provinceName = document.getElementById("provinceSelect").value
    const cityName = document.getElementById("citySelect").value
    const locationName = document.getElementById("locationName").value

    console.log("Form submission:", { countryName, provinceName, cityName, locationName })

    if (!countryName || !provinceName || !cityName || !locationName) {
        alert("Please fill in all required fields")
        return
    }

    try {
        console.log("Ensuring country exists:", countryName)
        const countryId = await ensureCountryExists(countryName)
        console.log("Country ID:", countryId)

        console.log("Ensuring province exists:", provinceName)
        const provinceId = await ensureProvinceExists(provinceName, countryId)
        console.log("Province ID:", provinceId)

        console.log("Ensuring city exists:", cityName)
        const cityId = await ensureCityExists(cityName, provinceId)
        console.log("City ID:", cityId)

        const locationData = {
            id: Number.parseInt(document.getElementById("locationId").value) || 0,
            name: locationName,
            address: document.getElementById("locationAddress").value || "",
            latitude: Number.parseFloat(document.getElementById("latitude").value) || null,
            longitude: Number.parseFloat(document.getElementById("longitude").value) || null,
            cityId: cityId,
        }

        console.log("Location data to save:", locationData)

        const isEdit = locationData.id > 0
        const url = isEdit ? `${API_BASE}/locations/${locationData.id}` : `${API_BASE}/locations`
        const method = isEdit ? "PUT" : "POST"

        const response = await fetch(url, {
            method: method,
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(locationData),
        })

        if (response.ok) {
            clearForm()
            loadLocations()
            loadLocationsOnMap() 
            alert(isEdit ? "Location updated successfully!" : "Location created successfully!")
        } else {
            const errorText = await response.text()
            console.error("Error response:", errorText)
            alert(`Error saving location: ${errorText}`)
        }
    } catch (error) {
        console.error("Error saving location:", error)
        alert(`Error saving location: ${error.message}`)
    }
}

async function ensureCountryExists(countryName) {
    try {
        const response = await fetch(`${API_BASE}/countries`)
        const countries = await response.json()

        let country = countries.find((c) => c.name === countryName)

        if (!country) {
            console.log("Creating new country:", countryName)
            const createResponse = await fetch(`${API_BASE}/countries`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ name: countryName, code: "" }),
            })

            if (!createResponse.ok) {
                const errorText = await createResponse.text()
                throw new Error(`Failed to create country: ${errorText}`)
            }

            country = await createResponse.json()
        }

        return country.id
    } catch (error) {
        console.error("Error ensuring country exists:", error)
        throw error
    }
}

async function ensureProvinceExists(provinceName, countryId) {
    try {
        const response = await fetch(`${API_BASE}/provinces`)
        const provinces = await response.json()

        let province = provinces.find((p) => p.name === provinceName && p.countryId === countryId)

        if (!province) {
            console.log("Creating new province:", provinceName)
            const createResponse = await fetch(`${API_BASE}/provinces`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ name: provinceName, code: "", countryId: countryId }),
            })

            if (!createResponse.ok) {
                const errorText = await createResponse.text()
                throw new Error(`Failed to create province: ${errorText}`)
            }

            province = await createResponse.json()
        }

        return province.id
    } catch (error) {
        console.error("Error ensuring province exists:", error)
        throw error
    }
}

async function ensureCityExists(cityName, provinceId) {
    try {
        const response = await fetch(`${API_BASE}/cities`)
        const cities = await response.json()

        let city = cities.find((c) => c.name === cityName && c.provinceId === provinceId)

        if (!city) {
            console.log("Creating new city:", cityName)
            const createResponse = await fetch(`${API_BASE}/cities`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ name: cityName, code: "", provinceId: provinceId }),
            })

            if (!createResponse.ok) {
                const errorText = await createResponse.text()
                throw new Error(`Failed to create city: ${errorText}`)
            }

            city = await createResponse.json()
        }

        return city.id
    } catch (error) {
        console.error("Error ensuring city exists:", error)
        throw error
    }
}

async function loadLocations() {
    try {
        const response = await fetch(`${API_BASE}/locations`)
        const locations = await response.json()

        const tbody = document.getElementById("locationsTableBody")
        tbody.innerHTML = ""

        if (locations.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="text-center">No locations found</td></tr>'
            return
        }

        locations.forEach((location) => {
            const row = document.createElement("tr")
            const coordinates =
                location.latitude && location.longitude
                    ? `${Number.parseFloat(location.latitude).toFixed(4)}, ${Number.parseFloat(location.longitude).toFixed(4)}`
                    : "N/A"

            row.innerHTML = `
                <td>${location.id}</td>
                <td>${location.name}</td>
                <td>${location.address || "N/A"}</td>
                <td>${location.city.name}</td>
                <td>${location.city.province.name}</td>
                <td>${location.city.province.country.name}</td>
                <td>${coordinates}</td>
                <td>
                    <button class="btn btn-sm btn-primary me-1" onclick="editLocation(${location.id})">Edit</button>
                    <button class="btn btn-sm btn-danger me-1" onclick="deleteLocation(${location.id})">Delete</button>
                    ${location.latitude && location.longitude ? `<button class="btn btn-sm btn-info" onclick="showOnMap(${location.latitude}, ${location.longitude}, '${location.name.replace(/'/g, "\\'")}')">Show on Map</button>` : ""}
                </td>
            `
            tbody.appendChild(row)
        })
    } catch (error) {
        console.error("Error loading locations:", error)
        document.getElementById("locationsTableBody").innerHTML =
            '<tr><td colspan="8" class="text-center text-danger">Error loading locations</td></tr>'
    }
}

function showOnMap(lat, lng, name) {
    map.setView([Number.parseFloat(lat), Number.parseFloat(lng)], 15)

    markers.forEach((marker) => {
        const markerLatLng = marker.getLatLng()
        if (
            Math.abs(markerLatLng.lat - Number.parseFloat(lat)) < 0.0001 &&
            Math.abs(markerLatLng.lng - Number.parseFloat(lng)) < 0.0001
        ) {
            marker.openPopup()
        }
    })
}

async function editLocation(id) {
    try {
        const response = await fetch(`${API_BASE}/locations/${id}`)
        const location = await response.json()

        // Populate form
        document.getElementById("locationId").value = location.id
        document.getElementById("locationName").value = location.name
        document.getElementById("locationAddress").value = location.address || ""
        document.getElementById("latitude").value = location.latitude || ""
        document.getElementById("longitude").value = location.longitude || ""

        document.getElementById("countrySelect").value = location.city.province.country.name
        currentCountryName = location.city.province.country.name
        await onCountryChange()

        setTimeout(async () => {
            document.getElementById("provinceSelect").value = location.city.province.name
            currentProvinceName = location.city.province.name
            await onProvinceChange()

            setTimeout(() => {
                document.getElementById("citySelect").value = location.city.name
            }, 500)
        }, 500)

        if (location.latitude && location.longitude) {
            showOnMap(location.latitude, location.longitude, location.name)
            setCurrentMarker(
                Number.parseFloat(location.latitude),
                Number.parseFloat(location.longitude),
                `Editing: ${location.name}`,
            )
        }
    } catch (error) {
        console.error("Error loading location for edit:", error)
    }
}

async function deleteLocation(id) {
    if (confirm("Are you sure you want to delete this location?")) {
        try {
            const response = await fetch(`${API_BASE}/locations/${id}`, {
                method: "DELETE",
            })

            if (response.ok) {
                loadLocations()
                loadLocationsOnMap() // Refresh map markers
                alert("Location deleted successfully!")
            } else {
                const errorText = await response.text()
                alert(`Error deleting location: ${errorText}`)
            }
        } catch (error) {
            console.error("Error deleting location:", error)
            alert(`Error deleting location: ${error.message}`)
        }
    }
}

function clearForm() {
    document.getElementById("locationForm").reset()
    document.getElementById("locationId").value = ""
    document.getElementById("provinceSelect").disabled = true
    document.getElementById("citySelect").disabled = true
    currentCountryName = ""
    currentProvinceName = ""
    clearTempMarkers()
}
