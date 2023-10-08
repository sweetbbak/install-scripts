#!/bin/bash

dir="${1:-/home/sweet/Pictures}"
# add option to exclude/include file types baby!
# mapfile -d '' array < <(fd . "$dir" --absolute-path -0 -tf -e png -e jpg -e gif -e svg -e webp -e jpeg|shuf)
mapfile -d '' array < <(fd . "$dir" --absolute-path -0 -tf -e gif)
clear

i=0
size=40
lx=0
ly=1
array_count="${#array[@]}"
count="(${i}/${array_count})"

bg="\e[1;3;38;5;50;48;5;212m"
clr="\e[0m"

#save screen
tput smcup

unhide_cursor() {
    printf '\e[?25h'
}

cleanup() {
    unhide_cursor
    tput rmcup
    clear
}

show_image() {
    # tput cup 0 0
    # tput cup $LINES 0;
        # tput el
        # tput cud1

    tput cup 0 0
    tput el
    printf "\e[40m\e[2K%s\e[0m\e[2;0H" "${count} ${image}"
    tput cup 1 0
    
    [ -f "$image" ] && { 
        kitty +kitten icat --clear --scale-up --place "${size}x${size}@${lx}x${ly}" "${image}"
        # printf "\e[1;35H\e[40m\e[2K%s %s\e[0m\e[2;0H" "$count" "$image"
        # tput cup $LINES 0;
        # gum style --align=center --width=$COLUMNS \
        #     --background=212 --foreground=50 \
        #     --bold --italic "${count} ${image}"
        # printf "%s%s%s" "${bg}" "$image" "$clr"
    }
    tput cup 1 0
}

array_cnt() {
    # if iterator i is less than or equal to 0
    # then loop back around by adding to entire count
    x=$i
    if [[ "$i" -le 0 ]]; then
        # array_count=$((array_count + i))
        x=$((array_count + i))
    fi
    count="(${x}/${array_count})"
}

array_count="${#array[@]}"
x="$i"

trap redraw WINCH
trap cleanup EXIT INT
# Hide the cursor (there is probably a much better way to do this)
printf '\e[?25l'

while true; do
    read -r -s -n 1 key < /dev/stdin > /dev/null
    # clear below x line with tput
    # tput cup 1 0
    # array_count="${#array[@]}"
    # count="(${x}/${array_count})"
    # check if count is less than 0 ie negative signed
    # and subtract from total to get the correct index
    array_cnt

    if [[ "$key" == j ]]; then
        i=$((i+1))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == k ]]; then
        i=$((i-1))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi
    if [[ "$key" == J ]]; then
        i=$((i+5))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == K ]]; then
        i=$((i-5))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == l ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        lx=$((lx+5))
        show_image
    fi
    if [[ "$key" == h ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        lx=$((lx-5))
        show_image
    fi
    if [[ "$key" == n ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        size=$((size-5))
        show_image
    fi

    if [[ "$key" == m ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        size=$((size+5))
        show_image
    fi
    if [[ "$key" == f ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        # feh --no-fehbg --bg-fill "$image"
        feh --bg-fill "$image"
    fi

    if [[ "$key" == x ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        cb copy "$image"
    fi

    if [[ "$key" == o ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        nsxiv "$image"
    fi

    if [[ "$key" == c ]]; then
        clear
        show_image
    fi

    if [[ "$key" == R ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        clear
        gum confirm && {
        /home/sweet/bin/rotate90.sh l "$image"
        sleep 0.2
        show_image
        } || notify-send "skipping" && show_image
    fi

    if [[ "$key" == r ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        clear
        gum confirm && {
        /home/sweet/bin/rotate90.sh r "$image"
        sleep 0.2
        show_image
        } || notify-send "skipping" && show_image
    fi

    if [[ "$key" == q ]]; then
        break
    fi
done
