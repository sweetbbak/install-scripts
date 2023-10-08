#!/bin/bash

printf "%s\n" "Ensure you are in a Wayland session"
# sudo waydroid init
# sudo waydroid init -s GAPPS -f

# sudo systemctl enable waydroid-container.service
waydroid session start
waydroid show-full-ui
waydroid shell

# Install an application:
# $ waydroid app install $path_to_apk

# Run an application:
# $ waydroid app launch $package-name #Can be retrieved with `waydroid app list`

# Network
# allow DNS traffic
# ufw allow 67
# ufw allow 53
# allow packet forwarding
# ufw default allow FORWARD

# For firewalld, you can use those commands:
#     DNS:
#         # firewall-cmd --zone=trusted --add-port=67/udp
#         # firewall-cmd --zone=trusted --add-port=53/udp

#     Packet forwarding:
#         # firewall-cmd --zone=trusted --add-forward
# firewall-cmd --runtime-to-permanent

# troubleshooting 
# waydroid upgrade
# stop and restart waydroid service
# waydroid init -f