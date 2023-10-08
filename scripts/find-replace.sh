#!/bin/bash
SHELL=/usr/bin/bash

# find . -type f -exec sed -i '/window.yaContextCb.push(()/d' {} \;

phrase_list=(
    "window.yaContextCb.push"
    "Join our Discord"
    "Join our discord"
    "Failed to download body"
    "on our website"
)

style(){
    gum style --border rounded --foreground=212 --border-foreground=212 --underline "$@"
}

dir=~/vmshare
# dir="$(pwd)"
empties=()
declare -x empties
# declare -f style

ripgrp() {
    dir="$1"
    r="$2"
    # while IFS= read -r -d $'\n' file; do
    #     empties+=("$REPLY")
    #     # echo "TIS WORKING"
    #     # echo "$REPLY"
    #     file_list=("${file_list[@]}" "$file")
    # done <  <(fd . "$dir" --print0 -t f -x rg -l "$r" {} \; -x echo {}\;)
    # echo "${empties[@]}"
    # sleep 1
    # echo "${file_list[@]}"

    mapfile -t empties < <(fd . "$dir" --print0 -t f -x rg -l -0 "$r" {} \;)

    if [ "${#empties[@]}" -eq 0 ]; then
        echo none
    else
        echo "${empties[@]}"
    fi
}

for r in "${phrase_list[@]}"; do
    style "SEARCHING FOR ${r} in ${dir}"
    ripgrp "$dir" "$r"
done
