#!/bin/bash

# url="https://nekos.best/api/v2/neko"
url="https://nekos.best/api/v2/"
dir="$HOME/Pictures/waifu"
# search?query=X&type=X&category=X&amount=X
# 1 for images 2 for gifs in the type=X field

[ ! -d "$dir" ] && {
    mkdir -p "$dir"
}

images=(
    endpoints
    husbando
    kitsune
    neko
    waifu
)
gifs=(
    baka
    bite
    blush
    bored
    cry
    cuddle
    dance
    facepalm
    feed
    handhold
    happy
    highfive
    hug
    kick
    kiss
    laugh
    nod
    nom
    nope
    pat
    poke
    pout
    punch
    shoot
    shrug
    slap
    sleep
    smile
    smug
    stare
    think
    thumbsup
    tickle
    wave
    wink
    yeet
)

both=("${nsfw_categories[@]}" "${sfw_categories[@]}")

print_help() {
    printf "%s\n" "USAGE:"
    printf "\t%s\n" "${0##*/} [OPTIONS]"
    printf "%s\n" "OPTIONS:"
    printf "\t%s\n" "-n,--nsfw"
    printf "\t%s\n" "-s,--sfw"
}

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--nsfw)
            choice="$(gum choose "${nsfw_categories[@]}")"
        ;;
        -s|--sfw)
            choice="$(gum choose "${sfw_categories[@]}")"
        ;;
        -h|--help)
            print_help
            exit 0
        ;;
        -t|--tag)
            shift
            choice="$1"
        ;;
        *)
            choice="$(gum choose "${both[@]}")"
        ;;
    esac
    shift
done

[ -z "$choice" ] && {
    choice="$(gum choose "${both[@]}")"
}

main() {
    choice="${choice//\"/}"
    choice="${url}/${choice}"

    temp="$(mktemp)"
    xh get "${choice}" > "$temp" 

    pic="$(jq '.url' < "$temp")"
    title="${pic##*/}"
    title="${title//\"/}"
    pic="${pic//\"/}"
    # pic="$(echo "$pic" | sed 's/\"//g')"
    out="${dir}/${title}"

    curl -s "$pic" --output $out
    kitty +kitten icat "$out"

    [ -f "$temp" ] && {
        rm "$temp"
    }
}

main