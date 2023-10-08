#!/bin/bash

text="$(wl-paste)"

get_cliphist() {
    cliphist list | wofi -d | cliphist decode | wl-copy
    text="$(wl-paste)"
}

aes_encrypt() {
    echo "$1" | openssl aes-256-cbc -a -salt -pass pass:sweet | wl-copy
}

aes_decrypt() {
    echo "$1" | openssl aes-256-cbc -d -a -pass pass:sweet | wl-copy
}

base64_encrypt() {
    echo "$1" | base64 | wl-copy
}

base64_decrypt() {
    echo "$1" | base64 -d | wl-copy
}

ecrypt_menu() {
    opt=$(printf "%s\n" "base64" "aes-256" | wofi -d)

    case "$opt" in
        base64) base64_encrypt "$text" ;;
        aes*) aes_encrypt "$text" ;;
    esac
}

base64_encrypt "$text"
