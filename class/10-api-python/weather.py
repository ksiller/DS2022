#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = ["requests"]
# ///

import requests

url = "https://api.open-meteo.com/v1/forecast/"

# Charlottesville
lat, lon = 38.0293, -78.4767

# payload as dictionary
w_params = {
    "latitude": lat,
    "longitude": lon,
    "current": ["temperature_2m", "wind_speed_10m"],
    "temperature_unit": "fahrenheit",
    "wind_speed_unit": "mph"
}

response = requests.get(url, params=w_params, timeout=10)
# Raises an error for bad status codes (4xx or 5xx)
response.raise_for_status()
# convert to JSON
data = response.json()
print (data)
