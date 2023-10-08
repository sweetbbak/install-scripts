#!/bin/bash
# a script that lets you select an area
# on the screen and then generates a color
# swatch from the image.
# currently requires grim, slurp and OKOLORS
# but could be modified to be used with hacksaw/slop and a screenshot tool
clipboard=wl-copy

cleanup() {
    rm "${tmp}.png"
    rm "${tmp}.txt"
}

trap cleanup EXIT 

take_swatch() {
    # tesseract auto adds .txt to the end of the outfile
    tesseract -l eng "${tmp}.png" "${tmp}"
    "$clipboard" < "${tmp}.txt"
    # wl-copy < "${tmp}.txt"
}

tmp="/tmp/tesseract-${RANDOM/??????/}"
grim -g "$(slurp -d)" "${tmp}.png"

[ -f "${tmp}.png" ] && {
    take_swatch
}

notify-send Screenshot -i "${tmp}.png"
