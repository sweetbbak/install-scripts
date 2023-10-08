#!/bin/bash
# a script to make it easy to copy and paste a group of
# consecutive files like file1, file2, file3 while copying
# things like novel chapters and such 

printf "%s\n" "Enter your files basename "
read -r -p "basename: " base_name

printf "%s\n" "You can start at a default of 1 or continue a previous session..."
printf "%s\n" "Enter file number to start at: "
read -r -p "index: " i

case $i in
    ''|*[!0-9]*) echo bad && exit ;;
    *) echo good > /dev/null ;;
esac

# re='^[0-9]+$'
# if ! [[ $i =~ $re ]] ; then
#    echo "error: Not a number" >&2; exit 1
# fi

printf "\n"

read -r -n 1 -p "Do you wish to start? " yn
case $yn in
    n) exit ;;
    * ) echo "ok :3";;
esac

read -r LINES COLUMNS < <(stty size)
tput clear

while true; do
    tput clear
    tput cup $((LINES - 1)) 0 && printf "%s\n" "(y)es | (n)o | (r)edo | (q)uit | (p)review "
    tput cup 0 0 && printf "%s\n" "${base_name}-${i}.txt"
    file="${base_name}-${i}.txt"
    text="$(wl-paste)"

    if [ -z "$old_text" ]; then
        echo a > /dev/null
    else 
        if diff <(echo "$text") <(echo "$old_text") >/dev/null ; then
            tput cup $((LINES - 3)) 0 && printf "%s\n" "Text is the same as laste paste"
        fi
    fi

    read -r -n 1 -p "Are you ready for the next file? " yn
    case $yn in
        # [Yy]* ) wl-paste > "${file}" ;;
        y|j) wl-paste > "${file}" && i=$((i + 1)) ;;
        n) echo moving_on > /dev/null;;
        r) clear && tput cup 0 0 && read -r -p "enter index to redo: " i ;;
        p) echo "${text}" | gum pager && clear ;;
        q) exit ;;
        # * ) wl-paste > "${file}" ;;
    esac
    old_text="$text"
    clear
done
    