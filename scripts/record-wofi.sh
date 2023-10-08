#!/bin/bash

cd "$HOME/Pictures/screenshots" || exit
title="$(date "+%m-%d-%Y-%I-%M-%S")"

select="$(printf "%s\n" "1:screenshot selection" "2:select active screen screenshot" "3:screenshot select => Clipboard" "4:Record MP4" "5:Record full screen as gif" "6: Record selection as gif"|\
    wofi --dmenu)"

case "$select" in
    1:*)
        # screenshot current window
        grim -g "$(slurp)" "screenshot-${title}.png"
        ;;

    2:*)
        # sc part of the screen
        grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" screenshot.png
        # grim -g "$(slurp)" - | swappy -f - -o - | pngquant -
        ;;

    3:*)
        # screenshot => to clipboard
        grim -g "$(slurp)" - | wl-copy
        ;;

    4:*)
        # record entire screen
        wf-recorder -f "screenshot-${title}.mp4"
        ;;

    5:*)
        # record entire screen
        wf-recorder -c gif -f "screenshot-${title}.mp4"
        ;;

    6:*)
        # record entire screen
        wf-recorder -g "$(slurp)" -c gif -f "screenshot-${title}.gif"
        ;;
esac

