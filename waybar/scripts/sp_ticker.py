#!/usr/bin/env python3

from subprocess import check_output
import json
import re
import datetime
import finance_macros

def pull_price_change_from_mb(exchange, symbol):
    url = f"https://www.marketbeat.com/stocks/{exchange}/{symbol}"
    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' 
    j = check_output(["curl", "--socks5-hostname", "127.0.0.1:9050", "-L", '-s', url, '-H', user_agent])

    addition = ""
    if "Extended Trading" in str(j):
        addition = '.*<div class="d-inline-block extended-hours mb-2">'

    price_change = "0.00"
    search = re.search(f'<strong style="color:.*&nbsp;(.*)</strong> <div class="price-updated">{addition}', str(j), re.IGNORECASE)
    if search:
        price_change = search.group(1).replace("(", "").replace(")", "").replace("%", "")

    return price_change


def format_price_change(price_change):
    if float(price_change) < 0:
        return price_change.replace("-", "⬇")
    elif float(price_change) > 0:
        return "⬆" + price_change.replace("+", "")

        
now = datetime.datetime.now()
if (now.time() >= datetime.time(8, 30) and
    now.time() <= datetime.time(15) and
             now.weekday() < 5):
    price_change = pull_price_change_from_mb("NYSEARCA", "SPY")
    color = "IndianRed" if float(price_change) < 0 else "DarkSeaGreen"
    j = {'text': f'SP <span color=\"{color}\">{format_price_change(price_change)}%</span>'}
    macro = finance_macros.get_macro_data()
    j['tooltip'] = macro['tooltip']
    print(json.dumps(j))
    with open('/home/john/.sp_ticker_last', 'w') as f:
        f.write(json.dumps(j))
else:
    with open('/home/john/.sp_ticker_last', 'r') as file:
        content = file.read()
        j = json.loads(content)
        j['text'] += ' 🌙'
        print(json.dumps(j))
