#!/bin/bash
# a script that lets you select an area
# on the screen and then generates a color
# swatch from the image.
# currently requires grim, slurp and OKOLORS
# but could be modified to be used with hacksaw/slop and a screenshot tool

cleanup() {
    rm "${tmp}.png"
}

trap cleanup EXIT 

take_swatch() {
    # if script is being ran from terminal then use it otherwise open a new one
    if [ -t 0 ] && [ -t 1 ]; then
        okolors "${tmp}.png" "${multi_swatch[@]}" -o swatch
    else
        kitty --hold --class=catnip3 -e okolors "${tmp}.png" "${multi_swatch[@]}" -o swatch
    fi
}

multi_swatch=(-w 0 -l "10,30,50,70" -n 3 -e 0.01)
tmp="/tmp/swatchshot-${RANDOM/??????/}"

echo "${tmp}"
grim -g "$(slurp -d)" "${tmp}.png"

[ -f "${tmp}.png" ] && {
    take_swatch
}

rm "${tmp}.png"
