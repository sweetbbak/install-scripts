#!/bin/bash

ran() {
    low=1
    hgh=256
    echo $((low + RANDOM%(1+hgh-low)))
}

for x in ~/**/*.sh; do gum style --foreground="$(shuf -n 1 -i 1-256)" "$x"; echo "$x"; done
