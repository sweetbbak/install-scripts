#!/bin/env python3
import os
import sys
import json
import requests
from bs4 import BeautifulSoup as bs
from rich import print

# from time import sleep
import argparse


def get_opts():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dl", "-d", action="store_true", default=False)
    parser.add_argument("--images", "-i", action="store_true", default=False)
    parser.add_argument("--html", "-H", action="store_true", default=False)
    parser.add_argument("--links", "-l", action="store_true", default=False)
    parser.add_argument("--url", "-u", type=str, required=False)

    return parser.parse_args()


pathName = os.getcwd()
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) "
    "Gecko/20100101 Firefox/103.0"
}


def get_html(url):
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()
        soup = bs(r.text, "lxml")
    except r.exceptions.HTTPError as err:
        print(err)
        print("Retrying...")
    return soup


# declaring an empty list outside of func so that I can append
# multiple pages if needed
manga = []


def to_json(manga):
    # time = datetime.now().strftime("%m%d-%H%M")
    with open("manga_as.json", "w") as f:
        json.dump(manga, f)


def to_file(image_links):
    with open("results.txt", "w", newline="\n") as f:
        f.write("\n".join(image_links))


def notify(message):
    os.popen(f'notify-send "{message}"')


def get_links(soup):
    links = soup.find_all("a")
    link = []
    for i in links:
        if i.get("href") is not None:
            link.append(i.get("href"))
        if i.get("src") is not None:
            link.append(i.get("src"))

    return link


def parse_html():
    pass


def main():
    parsed = get_opts()
    if parsed.url:
        x = get_html(parsed.url)
        # print(x)
    if parsed.links:
        links = get_links(x)
        for x in links:
            print(x, file=sys.stdout)
        # sys.stdout.write(links)
    if parsed.html:
        print()


main()
