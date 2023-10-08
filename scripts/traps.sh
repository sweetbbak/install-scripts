#!/bin/bash

url="https://api.waifu.pics"
dir="$HOME/Pictures/waifu"

[ ! -d "$dir" ] && {
    mkdir -p "$dir"
}

nsfw_categories=(
    nsfw/waifu
    nsfw/neko
    nsfw/trap
    nsfw/blowjob
)
sfw_categories=(
    sfw/waifu
    sfw/neko
    sfw/shinobu
    sfw/megumin
    sfw/bully
    sfw/cuddle
    sfw/cry
    sfw/hug
    sfw/awoo
    sfw/kiss
    sfw/lick
    sfw/pat
    sfw/smug
    sfw/bonk
    sfw/yeet
    sfw/blush
    sfw/smile
    sfw/wave
    sfw/highfive
    sfw/handhold
    sfw/nom
    sfw/bite
    sfw/glomp
    sfw/slap
    sfw/kill
    sfw/kick
    sfw/happy
    sfw/wink
    sfw/poke
    sfw/dance
    sfw/cringe
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