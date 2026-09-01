#!/usr/bin/env python3

from subprocess import check_output
import json
import re
import datetime

def pull_price_change_from_mb(exchange, symbol):
    url = f"https://www.marketbeat.com/stocks/{exchange}/{symbol}"
    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' 
    j = check_output(["curl", "-L", '-s', url, '-H', user_agent])

    addition = ""
    if "Extended Trading" in str(j):
        addition = '.*<div class="d-inline-block extended-hours mb-2">'

    price_change = "0.00"
    search = re.search(f'<strong style="color:.*&nbsp;(.*)</strong> <div class="price-updated">{addition}', str(j), re.IGNORECASE)
    if search:
        price_change = search.group(1).replace("(", "").replace(")", "").replace("%", "")

    return price_change

def format_price_change(price_change):
    f_price_change = float(price_change)
    if f_price_change < 0:
        return f"{f_price_change:.2f}".replace("-", "⬇")
    elif f_price_change > 0:
        return f"⬆{f_price_change:.2f}".replace("+", "")

portfolio = [['NYSE', 'XOM', 38+16],
             ['NYSE', 'FDX', 16],
             ['NYSE', 'CVS', 10.0583],
             ['NYSE', 'F', 128.3514],
             ['NASDAQ', 'PARA', 88.8569],
             ['NYSE', 'COP', 15]]

def get_portfolio_change():
    response = {}
    response['tooltip'] = ""
    
    total_shares = 0
    for i in portfolio:
        total_shares += i[2]

    weighted_pct = []
    for i in portfolio:
        price_change = pull_price_change_from_mb(i[0], i[1])
        color = "IndianRed" if float(price_change) < 0 else "DarkSeaGreen"
        response['tooltip'] += f'{i[1]:<4} : <span color=\"{color}\">{format_price_change(price_change)}%</span>\n'
        weight = i[2] / total_shares
        weighted_pct.append(float(price_change) * weight)

    total_change = round(sum(weighted_pct), 2)
    color = "IndianRed" if total_change < 0 else "DarkSeaGreen"
    response['text'] = f'P <span color=\"{color}\">{format_price_change(str(total_change))}%</span>'

    response['tooltip'] = response['tooltip'].strip()

    return response

        
now = datetime.datetime.now()
if (now.time() >= datetime.time(8, 30) and
    now.time() <= datetime.time(15) and
    now.weekday() < 5):
    response = get_portfolio_change()   
    print(json.dumps(response))
    with open('/home/john/.port_ticker_last', 'w') as f:
        f.write(json.dumps(response))
else:
    with open('/home/john/.port_ticker_last', 'r') as file:
        content = file.read()
        j = json.loads(content)
        j['text'] += ' 🌙'
        print(json.dumps(j))
