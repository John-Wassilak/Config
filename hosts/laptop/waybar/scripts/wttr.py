#!/usr/bin/env python3

import json
import requests
import time
from datetime import datetime

WEATHER_CODES = {
    '113': '☀️',
    '116': '⛅️',
    '119': '☁️',
    '122': '☁️',
    '143': '🌫',
    '176': '🌦',
    '179': '🌧',
    '182': '🌧',
    '185': '🌧',
    '200': '⛈',
    '227': '🌨',
    '230': '❄️',
    '248': '🌫',
    '260': '🌫',
    '263': '🌦',
    '266': '🌦',
    '281': '🌧',
    '284': '🌧',
    '293': '🌦',
    '296': '🌦',
    '299': '🌧',
    '302': '🌧',
    '305': '🌧',
    '308': '🌧',
    '311': '🌧',
    '314': '🌧',
    '317': '🌧',
    '320': '🌨',
    '323': '🌨',
    '326': '🌨',
    '329': '❄️',
    '332': '❄️',
    '335': '❄️',
    '338': '❄️',
    '350': '🌧',
    '353': '🌦',
    '356': '🌧',
    '359': '🌧',
    '362': '🌧',
    '365': '🌧',
    '368': '🌨',
    '371': '❄️',
    '374': '🌧',
    '377': '🌧',
    '386': '⛈',
    '389': '🌩',
    '392': '⛈',
    '395': '❄️'
}

data = {}

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate, br, zstd',
    'DNT': '1',
    'Sec-GPC': '1',
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'none',
    'Sec-Fetch-User': '?1',
    'Priority': 'u=0, i'
}


def make_request_with_retry(url, headers, max_retries=10, initial_delay=1, backoff_factor=2):
    attempts = 0
    while attempts < max_retries:
        try:
            response = requests.get(url, headers=headers, timeout=5) # Add a timeout to prevent indefinite hanging
            response.raise_for_status() # Raise an exception for bad status codes (4xx or 5xx)
            return response
        except requests.exceptions.RequestException as e:
            #print(f"Request failed (attempt {attempts + 1}/{max_retries}): {e}")
            if attempts < max_retries - 1:
                delay = initial_delay * (backoff_factor ** attempts)
                #print(f"Retrying in {delay:.2f} seconds...")
                time.sleep(delay)
            attempts += 1
    raise Exception(f"Failed to retrieve data from {url} after {max_retries} attempts.")



weather = make_request_with_retry("https://wttr.in/Midwest+City?format=j1", headers).json()


def format_time(time):
    return time.replace("00", "").zfill(2)

# ...what?
#def format_temp(te):
#    return (hour['FeelsLikeF']+"°").ljust(3)


def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        #"chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind"
    }

    conditions = []
    for event in chances.keys():
        if int(hour[event]) > 0:
            conditions.append(chances[event]+" "+hour[event]+"%")
    return ", ".join(conditions)


data['text'] = WEATHER_CODES[weather['current_condition'][0]['weatherCode']] + \
    " " + weather['current_condition'][0]['temp_F']+ "°"

data['tooltip'] = f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value']} {weather['current_condition'][0]['temp_F']}°</b>\t\t"
data['tooltip'] += f"Feels like: {weather['current_condition'][0]['FeelsLikeF']}°\n"
data['tooltip'] += f"Wind: {weather['current_condition'][0]['windspeedMiles']}m/h\t"
data['tooltip'] += f"Humidity: {weather['current_condition'][0]['humidity']}%\t"
data['tooltip'] += f"UV Index: {weather['current_condition'][0]['uvIndex']}\n"
data['tooltip'] += f"Last Updated: {weather['current_condition'][0]['localObsDateTime']}\n"

for i, day in enumerate(weather['weather']):
    data['tooltip'] += f"\n<b>"
    if i == 0:
        data['tooltip'] += "Today, "
    if i == 1:
        data['tooltip'] += "Tomorrow, "
    data['tooltip'] += f"{day['date']}</b>\n"
    data['tooltip'] += f"⬆️ {day['maxtempF']}° ⬇️ {day['mintempF']}° "
    data['tooltip'] += f" {day['astronomy'][0]['sunrise']}  {day['astronomy'][0]['sunset']} 😎 {day['uvIndex']}\n"
    for hour in day['hourly']:
        if i == 0:
            if int(format_time(hour['time'])) < datetime.now().hour-2:
                continue
        data['tooltip'] += f"{format_time(hour['time'])} {WEATHER_CODES[hour['weatherCode']]} {hour['tempF'] + '°'} {hour['weatherDesc'][0]['value']}, {format_chances(hour)}, UV {hour['uvIndex']}\n"


print(json.dumps(data))
