#!/bin/bash
sudo waydroid shell

cat << XXX > wl-copy
    chmod 777 -R /sdcard/Android
    chmod 777 -R /data/media/0/Android 
    chmod 777 -R /sdcard/Android/data
    chmod 777 -R /data/media/0/Android/obb 
    chmod 777 -R /mnt/*/*/*/*/Android/data
    chmod 777 -R /mnt/*/*/*/*/Android/obb
XXX
wl-paste