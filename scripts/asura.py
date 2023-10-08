#!/bin/env python3
import os
import json
import requests
from bs4 import BeautifulSoup as bs
from rich import print
from time import sleep
import argparse


def get_opts():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dl-chapter", "-d", type=str, required=False)


pathName = os.getcwd()
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) "
    "Gecko/20100101 Firefox/103.0"
}

url = "https://www.asurascans.com/"


def get_html(url):
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()
        soup = bs(r.text, "html.parser")
    except r.exceptions.HTTPError as err:
        print(err)
        print("Retrying...")
        sleep(5)
        get_html(url)
    return soup


# declaring an empty list outside of func so that I can append
# multiple pages if needed
manga = []


def get_titles(soup):
    reader = soup.find_all("div", class_="utao styletwo")

    for uta in reader:
        alink = uta.find("div", class_="imgu").find("a")
        link = alink.get("href")
        image = alink.find("img").get("src")
        title = alink.get("title")
        latest = uta.find("li").find("a").get("href")
        manga_info = {"title": title, "link": link, "latest": latest, "image": image}
        manga.append(manga_info)


def get_images(soup):
    # soup should be a link to an actual chapter
    images = []
    reader = soup.find("div", class_="rdminimal")
    paragraphs = reader.find_all("p")
    for x in paragraphs:
        img = x.find("img")
        img = img.get("src").rstrip()
        img = img.strip()
        images.append(img)
    return images


def to_json(manga):
    # time = datetime.now().strftime("%m%d-%H%M")
    with open("manga_as.json", "w") as f:
        json.dump(manga, f)


def to_file(image_links):
    with open("results.txt", "w", newline="\n") as f:
        f.write("\n".join(image_links))


def get_chapters(manga_url):
    # takes /manga/xxxxxxx-name-here url and returns all links
    mangal = []
    soup = get_html(manga_url)
    chlist = soup.find("div", id="chapterlist")
    links = chlist.find_all("a")

    for info in links:
        al = info.get("href")
        mangal.append(al)

    return mangal


def main():
    # get front page, parse titles and info
    html = get_html(url)
    # parse basic info - dump to json
    get_titles(html)
    to_json(manga)
    os.popen('notify-send "updating asurascans database"')


main()
