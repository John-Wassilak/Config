#!/usr/bin/python3

import requests
import json
import datetime

urls = [{"name": "IFD Prod",
         "url": "https://infocusdata.com/sitemap.xml"},
        {"name": "IFD Stg",
         "url" : "https://staging.infocusdata.com/sitemap.xml"}]

up_emoji = "🮱"
down_emoji = "❌"
green_start = "<span color=\"darkSeaGreen\">"
red_start   = "<span color=\"IndianRed\">"
end   = "</span>"

def is_url_up(url):
    try:
        response = requests.get(url['url'])
        if response.status_code == 200:
            return True
        else:
            return False
    except Exception as e:
            return False

def build_output():
    overall_status = True
    tooltip = ""
    
    for u in urls:
        if is_url_up(u):
            tooltip += f"{u['name']:<8} : {green_start}{up_emoji}{end}\n"
        else:
            tooltip += f"{u['name']:<8} : {red_start}{down_emoji}{end}\n"
            overall_status = False

    if overall_status:
        output = {"text": f"{green_start}{up_emoji}{end}"}
    else:
        output = {"text": f"{red_start}{down_emoji}{end}"}

    tooltip += f"{'last':<8} : {datetime.datetime.now().replace(microsecond=0)}"
    output['tooltip'] = tooltip

    return output

if __name__ == "__main__":
    print(json.dumps(build_output()))
