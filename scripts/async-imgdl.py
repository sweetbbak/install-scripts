# Making a new folder in the current dir.
import os
import sys
import requests
import time
import threading

image_url_list = []
filename = sys.argv[1]

with open(filename) as file:
    while (line := file.readline().rstrip()):
        image_url_list.append(line)

os.mkdir("Images")
os.chdir(os.path.join(os.getcwd(), "Images"))


def download(url, name):
    r = requests.get(url)
    f = open(name, "wb")
    f.write(r.content)
    f.close()
    print(name)


t1 = time.time()

threads = []

# for i in range(len(image_url_list)):
#     download(image_url_list[i],f"{i+1}.png")

for i in range(len(image_url_list)):
    temp = threading.Thread(target=download, args=[image_url_list[i], f"{i+1}.jpg"])
    temp.start()
    threads.append(temp)

for thread in threads:
    thread.join()

t2 = time.time()

print("Time takes : ", t2-t1)
