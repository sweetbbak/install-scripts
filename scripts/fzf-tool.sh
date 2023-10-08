#!/bin/bash
SHELL=/usr/bin/bash
updater="$HOME/dev/novelup/update.py"

set -- "${1:-/dev/stdin}" "${@:2}"
declare -x json
# json="$(jq '.' < "$1")"
# json="$(jq '.' < /home/sweet/dev/novelup/results.json)"
json="$(jq '.' < /home/sweet/dev/reaperscans-py/manga.json)"

# json_count="$(echo "$json" | jq -r '.[] | @base64'|wc -l)

parse() {

    printf "%s\n" "$json" | jq ".[${1}]"|jq '.title, .status, .rating, .link'
        # gum style \
        #     --padding "0 1" \
        #     --border rounded \
        #     --align left \
        #     --width 95 \
        #     --margin "0 1")

    # get the corresponding image from our json
    image=$(printf "%s\n" "$json"|jq ".[${1}].image"| sed 's/\"//g')
        # this expansion below grabs the last field of the url for our output name
        output=$(printf "%s" "${image##*/}")
        # if our image doesnt already exist then get it
        output="$HOME/dev/nvl-imgs/${output}"
        if ! [ -f "$output" ]; then
            curl -s -A 'uwu' "$image" --output "${output}"
        fi
    # kitty +kitten icat --align left "$output"
    kitty @ send-text -m "not state:focused" "clear \r"
    kitty @ send-text -m "not state:focused" "kitty +kitten icat --clear --scale-up --place 35x35@0x0 ${output} \r"
}

titles() {
    title=$(jq ".[].title" < "$json")
    printf "%s\n" "$title"
}

updatepy() {
    python3 "$updater"
}

export -f parse

# launch a window
kitty @ launch --type=window --title fzimg --keep-focus --location=split 

    printf "%s\n" "$json" | jq '.[].title' | fzf --cycle \
        --border=rounded \
        --bind "left:execute()" \
        --bind "right:execute()" \
        --preview 'parse {n}' \
        --bind 'enter:execute(echo {} > /dev/tty && kitty @ close-window -m "title:^fzimg")+abort'

# export -f fzmain
