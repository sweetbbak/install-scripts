#!/bin/bash

icat="kitty +kitten icat --scale-up --place 70x70@0x0 --clear"

# our fifo
pipe=/tmp/sex
# on exit remove fifo
trap 'rm -f "$pipe"' EXIT

# if no pipe, then pipe duh
if [[ ! -p $pipe ]]; then
    mkfifo "$pipe"
fi

# while stuff come out do stuff lol
while read -r line < $pipe
do
    if [[ "$line" == 'quit' ]]; then
        break
    fi

    # linetype="$(file "$line")"
    # case $linetype in
    # *image*) $icat "$line";;
    # *) echo "not an image";;
    $icat "$line"
    # esac
done