#!/usr/bin/env python3

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

#define some varibles
target_site = ""
target_site = input("please provide the link of a site that you would like to perform scrapping against(start with 'http(s)'): ")


#Make a request to the website
r = requests.get(target_site)

#Use html parser to paser the content
soup = BeautifulSoup(r.content, 'html.parser')

#print the content
print(soup.prettify())

#innitialise an empty set to store unique URLs
unique_internal_links=set()

#Find all 'a' tags
links= soup.find_all('a')

#Iterate over all found links
for link in links:
    #get the href attribute from the 'a' element
    href = link.get('href')

    #if href is not None and is an internal link
    if href and not href.startswith('http'):
        full_url = urljoin(target_site, href)
    
    #Add the URL to the set
        unique_internal_links.add(full_url)

# print all the unique internal links:
if unique_internal_links:
    print("\nINFO: here are detected sub-pages")
    for link in unique_internal_links:
        print(link)   
else:
    print("INFO: No sub-pages detected.")


