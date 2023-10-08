#!/bin/bash
# Start moonlight
# First add port-forwarding on your router
# just follow moonlight instructions word for word under
# the port-forwarding section ie internal IP = external IP
# https://localhost:47990/

if [ "${EUID}" -ne 0 ]; then
    echo "run as sudo"
fi
# then run these firewall cmds
firewall-cmd --add-port={47984,47989,48010}/tcp
firewall-cmd --add-port={5353,47998,47999,48000,48002,48010}/udp
firewall-cmd --add-port=59999/udp
firewall-cmd --add-port=59999/tcp

# either enable sunshine with systemd or start sunshine
# systemctl --user enable --now sunshine 

if pgrep sunshine &>/dev/null; then
    echo sunshine is running
else
    echo starting
    su "$USER" -c sunshine
fi 
# MoonDeckBuddy.AppImage --exec MoonDeckStream