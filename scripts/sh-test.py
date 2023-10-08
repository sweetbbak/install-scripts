#!/bin/env python3
import sh

# from sh import find

files = sh.fd(".", "/home/sweet/", "-e", "png")
print(files)
print(sh.wc(sh.ls("-1"), "-l"))
