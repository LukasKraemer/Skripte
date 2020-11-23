import requests
from fake_useragent import UserAgent
import random
import time
import urllib

# SEO Tool
# Lukas Krämer 2020 - 
# MIT License


# define Url and Values

url= [
     {'url': 'https://www.test.de/shop/test-hefte/test_12_2019/', 'suchwort': "test12"},
     {'url': 'https://www.google.com/', 'suchwort': "google"}
        
]

#define sleeper in sec
minTime = 30
maxTime = 500


def randomtask(times):
    if times == 2:
        time.sleep(random.randrange(1, 6))
    if times ==1:
        time.sleep(random.randrange(1, 3))
    if times ==0:
        5+5  


    task= random.randrange(1, 6)

    if task==1:
        4+2+6+3+24
    if task ==2:
        5*3+5123
    if task ==3:
        532*3+5123    
    if task ==4:
        try:
            5123123/123        
        except:
            0
    if task ==5:
        1+1
    if task ==6:
        try:
            999999999999999/124     
        except:
            1+1       




i=0
while True:

    targetnum = random.randrange(0, len(url))
    targeturl= urllib.parse.quote_plus(url[targetnum]['url']) 
    suchwort= url[targetnum]['suchwort'].replace( " ", "+")

    time.sleep(random.randrange(minTime, maxTime)) # randomize sleep

    ua = UserAgent() # get random useragend
    r = requests.Session() #start request session

    header = {'User-Agent':str(ua.random)} #set header with useragend
    url = "https://www.google.com/" #google search url
    parameter = f"search?q={suchwort}" # get parameter to search
   
    parameter2 =f"https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&url={targeturl}" #open side


    
    r1 = r.get(url, headers=header) #open google
    randomtask(1) # wait random time
    searching=""
    for y in suchwort:
        searching += y
        randomtask(0)
        rx = r.get(url=url+f"/complete/search?q={searching}&cp=2&client=psy-ab",cookies=r1.cookies, headers=header) # search for word
        print(rx.status_code)

    r2 = r.get(url=url+parameter,cookies=r1.cookies, headers=header) # search for word
    randomtask(3)# wait random time
    r3 = r.get(url=parameter2, cookies=r2.cookies, headers=header)# open link
    randomtask(0)
    i+=1
    if(r3.status_code == 200):
        print(f"Erfolgreich {i}")
    else:
        print(f"Error at {i}")
    del r1,r2,r3,rx,y,ua, targetnum, targeturl, suchwort   
