import os
import sys
import requests
from rich import print
from bs4 import BeautifulSoup as bs
import time
import pyfzf

# get working directory
pathname = os.getcwd()

# user agent, important.
headers = {
    'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) "
    "Gecko/20100101 Firefox/103.0 "
}

# base_url = "https://reaperscans.com/novels/5603-infinite-mage/chapters/"

host_url = sys.argv[1]
outfile = sys.argv[2]

chapter_links = []
# x = sys.stdin


def get_html(url):
    # request html and return html parsed object
    r = requests.get(url, headers=headers)
    print(r.status_code)
    # if our status code isn't out of range then get html
    if r.ok:
        soup = bs(r.text, 'html.parser')
        return soup
    # if we get a failure then wait 20 seconds and try again
    else:
        time.sleep(20)
        r = requests.get(url, headers=headers)
        soup = bs(r.text, 'html.parser')
        return soup


def parse(html):
    # iterate a code block that contains our links starting with main block
    # links = html.find('div', class_="pb-4").find('ul', role="list")
    # find exact container tag of our target
    # links = html.find_all(sys.argv[2], class_=sys.argv[3])
    links = html.find_all('a')
    # for each html tag, get the a href link and append it to our list
    for link in links:
        # link = link.find('a')
        link = link.get('href')
        chapter_links.append(link)


soup = get_html(host_url)
res = parse(soup)
# print(chapter_links)
z = open(outfile, 'w')
for x in chapter_links:
    print(f"{host_url}{x}")
    # sys.stdout.write(f"{host_url}{x}")
    z.writelines(x)

x.close()
