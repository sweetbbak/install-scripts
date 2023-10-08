#!/bin/bash
# script to download to the steamdeck

url="${1}"

send() {
    if ! ssh steamdeck "cd Downloads && wget ${url}"; then
        notify-send "Steamdeck is not on"
    else
        pass
    fi
}

send