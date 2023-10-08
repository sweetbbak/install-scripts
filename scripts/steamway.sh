#!/bin/bash
# simple script that lets you run a steam game from the CLI
# edit the game_run variable to meet your needs.
# requires Fzf and ncurses (tput - in most distros by default)

game_run="gamescope -W 1920 -H 1080 -- "

# suppress output
stty -echo
# stty echo
# hide cursor
# printf '\e[?25l'
tput civis


cleanup() {
    clear
    tput cnorm
    stty echo
}


game=$(
    fzf --cycle \
        --height=15 \
        --reverse < <(find ~/.local/share/Steam/steamapps ~/ssd/SteamLibrary/steamapps \
        -maxdepth 1 -type f -name '*.acf' \
        -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; \
        | column -t -s '|' \
        | sort -k 2 )
)

[ -z "$game" ] && exit

trim_string() {
    # Usage: trim_string "   example   string    "
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

game_id="$( echo "$game" | awk -F' ' '{ print $1 }' )"
game_title="${game//${game_id}/}"
game_title="$(trim_string "$game_title")"

menux() {
    tput civis
    index=1
    clear
    key="j"
    while true; do
        tput cup 0 0 && printf '\e[35m%s\e[0m\n' "Would you like to run this game?"
        tput cup 1 0 && printf '\e[33m%s\n' "${game_title} - ${game_id}"
    if ((index == 0)); then
        tput cup 2 0 && printf '\e[2k' && printf '\e[31m%s\e[0m\n' "> Yes"
        tput cup 3 0 && printf '\e[2k' && printf '\e[32m%s\e[0m\n' "  No"
    else
        tput cup 2 0 && printf '\e[2k' && printf '\e[32m%s\e[0m\n' "  Yes"
        tput cup 3 0 && printf '\e[2k' && printf '\e[31m%s\e[0m\n' "> No"
    fi

        # read no backslashes, silent, 1 key at a time
        case "$key" in
            j|$'\x1b\x5b\x41') if [ "$index" = 0 ]; then index=1 ; elif [ "$index" = 1 ]; then index=0 ; fi ;;
            k|$'\x1b\x5b\x42') if [ "$index" = 0 ]; then index=1 ; elif [ "$index" = 1 ]; then index=0 ; fi ;;
            $'\x0a') break ;;
            *) echo >/dev/null ;;
        esac

        unset K1 K2 K3
        read -sN1
        K1="$REPLY"
        read -sN2 -t 0.001
        K2="$REPLY"
        read -sN1 -t 0.001
        K3="$REPLY"
        key="$K1$K2$K3"

    done
    # index will be 1 or 0 which is also return codes for success and fail
    # used for the last condition on whether to start the game or not
    return "$index"
}

if ! menux; then
    cmd="${game_run} steam steam://rungameid/${game_id}"
    echo -ne "\e[31mStarting $game_title\e[0m\n"
    eval "$cmd"
    echo true
else
    echo -ne "\e[31mOkay then :P\e[0m\n"
fi

trap cleanup EXIT
# stty echo
# tput cnorm
exit $?
