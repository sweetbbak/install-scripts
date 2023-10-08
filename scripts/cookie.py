#!/bin/env python3
import os
import subprocess
import socket
from rich import print
# import requests
from urllib.request import Request, urlopen

local = os.getenv('LOCALAPPDATA')
roaming = os.getenv('APPDATA')
temp = os.getenv("TEMP")
try:
    print("{0} | {1} | {2}".format(local, roaming, temp))
except:
    pass

fff = os.get_exec_path()
print(fff)


def get_ip():
    ip = "None"
    try:
        ip = urlopen(Request("https://api.ipify.org")).read().decode().strip
    except:
        ip = subprocess.check_output('curl ifconfig.me', shell=True).decode('utf-8').strip()
    return ip


x = get_ip()
print(x)
for name, value in os.environ.items():
    print("{0}: {1}".format(name, value))

ip = subprocess.check_output('curl ifconfig.me', shell=True).decode('utf-8').strip()
print(ip)

host = socket.gethostname()
print(host)