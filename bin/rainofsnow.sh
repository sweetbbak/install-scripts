#!/bin/bash
# A script to download a chapter list and chapters of a novel
# from Rainofsnow.com - please consider donating to them if you
# use this script. They are run by regular students who are passionate 
# about Korean novels and I dont want to see them go away
# set -x

cleanup() {
    [ -z "$temp" ] && rm "$temp"
}

trap cleanup EXIT SIGINT
cd "$(pwd)" || exit

url="$1"
[ -z "$url" ] && printf "%s\n" "Enter URL: " && read -r url 

if grep "https://rainofsnow" <<< "$url" >/dev/null; then
    printf '\e[38;5;110mRain of snow\n\e[0m'
fi

temp=$(mktemp)
# title="$(sed -e 's&https://rainofsnow.com/&&g' <<< "$url" )"
title="${url/https:\/\/rainofsnow.com\//}"
mkdir "$title" && cd "$title" || exit 1

if curl -sL -A "uwu" "$url" > "$temp"; then
    printf '\e[38;5;110mScraping %s\n\e[0m' "$title"
else
    printf '\e[38;5;133mCouldnt reach: %s\n\e[0m' "$url"
    exit 1
fi

get_chapter_text() {
    cat "$1" \
        | pup -p --charset UTF-8 '.bb-item[style*="block"] .content .scroller div[class="zoomdesc-cont"] span text{}' \
        | perl -pe 's/[^[:ascii:]]//g' \
        | sed -e '/^[[:space:]]*$/d' -e 's/^[ \t]*//' > "${1}.txt"
    rm "$1"
}

request() {
    urlx="$(echo "$1" | tr -d \')"
    chtitle="$2"

    if curl -sL -A "uwu" "$urlx" > "$chtitle"; then
        printf '\e[38;5;110mDownloading: %s\n\e[0m' "${chtitle}"
        get_chapter_text "$chtitle"
        unset -v urlx
        unset -v chtitle
        return 0
    else
        printf '\e[38;5;133mCouldnt download: %s\n\e[0m' "$urlx"
        unset -v urlx
        unset -v chtitle
        return 1
    fi

}

get_index() {
    cat "$temp" | pup 'ul[class=march1]' | pup 'li' \
        | grep -o '<a href=.*' \
        | sed -e 's/<a href="//g' -e 's/">//g' > "${title}-ch.txt"
}

if get_index; then
    printf '\e[38;5;110mDownloaded chapter index of Rain of snow\n%s \e[0m' "$title"
    readarray links < <(cat "${title}-ch.txt")
else
    printf '\e[38;5;133mError getting links\e[0m'
    exit 1
fi

download_links() {
    [ -z "${links[*]}" ] && { exit ; }

    declare -a link_err
    declare -a titles

    for x in "${links[@]}"; do
        printf '\e[38;5;110m%s\n\e[0m' "$x"
        chapter_title="$(echo "$x" | sed -e 's|https://rainofsnow.com/chapters/||g' -e 's|/?novelid=[1-9]*||g')"
        if ! request "$x" "$chapter_title"; then
            sleep 3
            link_err+=("$x")
        else
            sleep 1
            titles+=("$x")
        fi
    done
    [ -n "${link_err[*]}" ] && echo "${link_err[@]}"
}

select_links() {
    [ -z "${links[*]}" ] && { exit ; }

    links="$( gum choose --no-limit "${links[@]}" )"
    for x in "${links[@]}"; do
        printf '\e[38;5;110m%s\n\e[0m' "$x"
        chapter_title="$(echo "$x" | sed -e 's|https://rainofsnow.com/chapters/||g' -e 's|/?novelid=[1-9]*||g')"
        if ! request "$x" "$chapter_title"; then
            link_err+=("$x")
        else
            titles+=("$x")
        fi
    done
}

download_links
