import requests
import copy
import re
from lxml import html
from bs4 import BeautifulSoup
from collections import OrderedDict

#Need to get info on restaurants for markers, as well as show title
#Do it as a 3d list, parse for title in beginning
def get_addresses():
    #Starting point: get the show list from here
    state_restaurants = []
    page = requests.get('https://www.foodnetwork.com/restaurants/shows/diners-drive-ins-and-dives')
    webpage = html.fromstring(page.content)

    #Get a list of all the shows
    states = []
    for link in webpage.xpath('//a/@href'):
        if str(link).find("www.foodnetwork.com/restaurants/shows/diners-drive-ins-and-dives/") != -1:
            states.append(link)
    #states = [state[state.rfind('/') + 1:] for state in states]
    states = ["http://" + str(state[2:]) for state in states] #remove //
    states = list(OrderedDict.fromkeys(states[1:]))

    address_start = '<div class="m-Info__a-Address" data-type="maps-btn">'
    address_end = '<span class="m-Info__a-Pipe"> | </span>'
    info_start = '<div class="m-MediaBlock__a-Description"><p></p><p>'
    info_end = 'Seen an error?'

    names = []
    for state in states:
        state_name = state[state.rfind("/") + 1:]
        if state_name.find("restaurants-in") != -1:
            state_name = state_name[len("restaurants-in-"):]
        names.append(state_name.capitalize())

    count = 0
    for state in states:
        state_restaurants.append(names[count])
        print(names[count])
        count+=1
        
        state_link = requests.get(state)
        states_webpage = html.fromstring(state_link.content)
        restaurants = [] 
        for link in states_webpage.xpath('//a/@href'):
            if str(link).find("www.foodnetwork.com/restaurants/") != -1:
                restaurants.append(link)
        restaurants = ["https:" + r if r.startswith("//www") else r for r in restaurants[6:]]
        restaurants = list(OrderedDict.fromkeys(restaurants))
        state_temp = []
        
        for restaurant in restaurants:
            try:
                restaurant_link = requests.get(restaurant)
                soup = BeautifulSoup(restaurant_link.content.decode("utf-8", errors='ignore'),'html.parser')

                name = str(soup.find("title").get_text())
                name = name[:name.find("|")].strip()
                
                address = str(soup.findAll("div", {"class": "m-Info__a-Address"})[0])
                address = address[len(address_start):address.find(address_end)].strip()
                
                info = str(soup.findAll("div", {"class": "m-MediaBlock__a-Description"})[0])
                info = info[len(info_start):info.find(info_end)].strip()
                soup = BeautifulSoup(info, features="lxml")
                info = soup.get_text()
                
                #print(name, address, info, sep=", ")
                #print()
                
                state_temp.append([name, address, info])
            except Exception:
                continue

        
        state_restaurants.append(state_temp)
        
    with open('data.dat', 'w', encoding='utf8') as f:
        for state in state_restaurants:
            if isinstance(state, str):
                f.write(state + '\n')
            else:
                for item in state:
                    for subitem in item:
                        f.write(subitem + '\n')
                    f.write('\n')
            f.write('\n')
temp = get_addresses()

#print(len(temp))
#print(len(temp[0]))
#print(temp[3])
#print(temp)
