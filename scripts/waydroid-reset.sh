#!/bin/bash
# Script to remove Waydroid artifacts

remove() {
    rm -rf /var/lib/waydroid /home/.waydroid
    rm -rf ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
}

echo -e "Delete Waydroid Image and user data?\n"
gum confirm && remove