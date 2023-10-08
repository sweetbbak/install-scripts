#!/bin/bash
if [ "$EUID" != 0 ]; then
 echo "$(zenity --password)" | sudo -S -u "$0" "$@"
 exit $?
fi
 sudo mount --bind /home/sweet/Documents /home/sweet/.local/share/waydroid/data/media/0/Documents 
 sudo mount --bind /home/sweet/Downloads /home/sweet/.local/share/waydroid/data/media/0/Download 
 sudo mount --bind /home/sweet/Music /home/sweet/.local/share/waydroid/data/media/0/Music 
 sudo mount --bind /home/sweet/Pictures /home/sweet/.local/share/waydroid/data/media/0/Pictures 
 sudo mount --bind /home/sweet/Videos /home/sweet/.local/share/waydroid/data/media/0/Movies
