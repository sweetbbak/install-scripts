#!/bin/bash

json="$(jq '.' < /home/sweet/dev/novelup/results.json)"
# printf "%s\n" "$json"

style() {
    printf "%s\n" "$1"|jq ".[${2}]"|jq '.title, .status, .rating, .link'| \
        gum style \
            --padding "0 1" \
            --border rounded \
            --border-foreground 212 \
            --align left \
            --width 95 \
            --margin "0 1"

    # get the corresponding image from our json
    image=$(printf "%s\n" "$1"|jq ".[${2}].image"| sed 's/\"//g')
        # this expansion below grabs the last field of the url for our output name
        output=$(printf "%s" "${image##*/}")
        # if our image doesnt already exist then get it
        output="$HOME/dev/nvl-imgs/${output}"
        if ! [ -f "$output" ]; then
            curl -s -A 'uwu' "$image" --output "${output}"
        fi
    kitty +kitten icat --align left "$output"
    printf "%s\n" " "
        
}

# this is a handy and easy way to get the count of objects in our simple json
# "-r | --raw-output" and base64 is to bring them down to one object per line
# -r may not even be necessary from my tests unless re-merging the raw json 
# and not a variable form.

bar() {
    # gum style --width "$COLUMNS" --background=1 ' '
    printf "%s\n" ' '
    text="$(gum style --bold --foreground=0 --background=1 'j up | k down | q quit')"
    text2="$(gum style --bold --foreground=0 --background=1 --background=1 "(${x}/${json_count})")"
    tc1="$(echo "$text" | wc -L)"
    # tc2="$(echo "$text2" | wc -L)"
    space=$((COLUMNS / 2 - tc1))
    space=$(indent $space)
    space="$(gum style --background=240 "$space")"

    gum style --width "$COLUMNS" --background=240 "${text}${space}${text2}"
    
}

indent() {
  for i in $(seq 1 "$1"); do printf ' '; done
}

ctrl_c() {
  clear
  printf '\e[?25h'
  exit
}

get_term_size() {
  read -r LINES COLUMNS < <(stty size)
}

up() {
    if [ "$x" -lt "$json_count" ]; then
        x=$((x+1))
        clear
        style "$json" "$x"
    elif [ "$x" = "$((json_count - 1))" ]; then
        x=0
        clear
        style "$json" "$x"
    fi    
}

down() {
    if [ "$x" -lt "$json_count" ]; then
        x=$((x-1))
        clear
        style "$json" "$x"
    elif [ "$x" = "$((json_count + 1))" ]; then
        x=0
        clear
        style "$json" "$x"
    fi

}

q() {
    trap ctrl_c INT
    printf '\e[?25h'
    exit
}

# remember to start at 0
json_count="$(echo "$json" | jq -r '.[] | @base64'|wc -l)"

# Save the user's terminal screen.
# printf '\e[?1049h'
# hide the cursor
printf '\e[?25l'

quit='false'
x=0

clear
while [ ${quit} != 'true' ]; do
    # trap ctrl+c to unhide cursor and reset terminal
    trap ctrl_c INT
    # take input from user
    read -rsn1 input </dev/tty

    case "$input" in
    'k') up;bar;;
    'j') down;bar;;
    'q') q;;
    esac
done

printf '\e[?25h'
trap ctrl_c INT
# Restore the user's terminal screen.
# printf '\e[?1049l'

# read -r -a MY_ARR <<< "Linux is awesome."

# for i in "${MY_ARR[@]}"; do 
  # echo "$i"
# done
