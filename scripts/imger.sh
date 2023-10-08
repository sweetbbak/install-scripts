#!/bin/bash

dir="${1:-/home/sweet/Pictures}"

mapfile -d '' array < <(fd . "$dir" -0 -tf -e png -e jpg -e gif -e svg -e webp -e jpeg )
clear

i=0
size=100
lx=0
ly=0

while true; do
    read -r -t 1 -n 1 key > /dev/null

    if [[ "$key" == j ]]; then
        i=$((i+1))
        image="${array[$i]}"
        image="${image// /\ }"

        [ -f "$image" ] && { 
            kitty +kitten icat --clear --scale-up --place 100x100@0x0 "${image}"
        }
    fi

    if [[ "$key" == k ]]; then
        i=$((i-1))
        image="${array[$i]}"
        image="${image// /\ }"
        [ -f "$image" ] && { 
            kitty +kitten icat --clear --scale-up --place 100x100@0x0 "${image}"
        }
    fi

    if [[ "$key" == l ]]; then
        i=$((i-1))
        image="${array[$i]}"
        image="${image// /\ }"
        [ -f "$image" ] && { 
            kitty +kitten icat --clear --scale-up --place 100x100@0x0 "${image}"
        }
    fi

    if [[ "$key" == q ]]; then
        break
    fi
done
