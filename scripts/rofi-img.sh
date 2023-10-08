#!/bin/bash
# one-liner image picker
fd . "${1}" -e png -e webp -e jpg -x printf "\x00icon\x1f%s\n" \
    | rofi -I -show-icons -dmenu -p -theme ~/gruvbox-common.rasi > /dev/stdout
    # | rofi -I -show-icons -dmenu -p -theme ~/gruvbox-dark-hard.rasi > /dev/stdout
    # | rofi -I -show-icons -dmenu -p > /dev/stdout
    # | rofi -dmenu -p  -theme ~/dev/image-picker-rofi/games.rasi > /dev/stdout
