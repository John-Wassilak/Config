#!/usr/bin/env python3

from subprocess import check_output
import json
import re
import datetime
import os.path


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
    if float(price_change) < 0:
        return price_change.replace("-", "⬇")
    elif float(price_change) > 0:
        return "⬆" + price_change.replace("+", "")

def pull_eps_yield():
    url = "https://www.multpl.com/s-p-500-earnings-yield"
    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' 
    j = check_output(["curl", "-L", '-s', url, '-H', user_agent, '--insecure'])

    eps_yield = "0.00%"
    search = re.search(f'Current S&P 500 Earnings Yield is (.*)%, a change of', str(j), re.IGNORECASE)
    if search:
        eps_yield = search.group(1)

    return float(eps_yield)

def pull_US10Y():
    url = 'https://www.cnbc.com/quotes/US10Y'
    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' 
    j = check_output(["curl", "-L", '-s', url, '-H', user_agent])
    t_yield = "0.00%"
    search = re.search(f'"exchange":"Tradeweb","price":"(.*)%","priceChange"', str(j), re.IGNORECASE)
    if search:
        t_yield = search.group(1)

    return float(t_yield)

def pull_inflation():
    url = 'https://www.usinflationcalculator.com/inflation/current-inflation-rates/'
    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' 
    j = check_output(["curl", "-L", '-s', url, '-H', user_agent])
    inf = "0.00%"
    search = re.search(f'The annual inflation rate for the United States was ([0-9\\.]*)% for the', str(j), re.IGNORECASE)
    if search:
        inf = search.group(1)

    return float(inf)

def pull_GDP_G():
    url = 'https://www.multpl.com/us-real-gdp-growth-rate'
    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' 
    j = check_output(["curl", "-L", '-s', url, '-H', user_agent, '--insecure'])
    gdp = '0.00'
    search = re.search(f'Current US Real GDP Growth Rate is (.*)%.\" />', str(j), re.IGNORECASE)
    if search:
        gdp = search.group(1)
        
    return float(gdp)
    

def pull_macro():
    response = {}
    response['date'] = str(datetime.date.today())
    response['tooltip'] = f'SP_EPS_Y : {pull_eps_yield():.2f}%\n'
    response['tooltip'] += f'US10YT_Y : {pull_US10Y():.2f}%\n'
    response['tooltip'] += f'INF_Rate : {pull_inflation():.2f}%\n'
    response['tooltip'] += f'GDP_Grow : {pull_GDP_G():.2f}%'

    return response

fname = '/home/john/.macro_last'

def write_file(fname):
    with open('/home/john/.macro_last', 'w') as f:
        macro = pull_macro()
        f.write(json.dumps(macro))

        return macro

def get_macro_data():    
    try:
        if os.path.isfile(fname):
            with open(fname, 'r') as file:
                content = file.read()
                j = json.loads(content)
                if j['date'] != str(datetime.date.today()):
                    return write_file(fname)
                else:
                    return j
        else:
            return write_file(fname)
    except:
        return write_file(fname)

get_macro_data()
