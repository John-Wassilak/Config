#!/usr/bin/env python3

import json
import requests

#url = f"https://api.openweathermap.org/data/2.5/weather?lat=35.457&lon=-97.321&appid=c64156d1b79b42f68bf4987e780a81eb"

lat = "35.457"
lon = "-97.321"
api_key = "c64156d1b79b42f68bf4987e780a81eb"

forecast_url = f"api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={api_key}"

#weather = requests.get(url).json()

print(forecast_url)
