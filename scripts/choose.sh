#!/bin/bash
# simple script for an interactive YES/NO prompt
# set -x

menu() {
    tput civis
    index=0
    def="Continue? "
    clear
    key="j"

    prompt="${1:-$def}"
    prompt2="${2:-}"

    while true; do
        tput cup 0 0 && printf '\e[35m%s\e[0m\n' "${prompt}"
        tput cup 1 0 && printf '\e[33m%s\n' "${prompt2}"
    if ((index == 1)); then
        tput cup 2 0 && printf '\e[2k' && printf '\e[31m%s\e[0m\n' "> Yes"
        tput cup 3 0 && printf '\e[2k' && printf '\e[32m%s\e[0m\n' "  No"
    elif ((index == 0)); then
        tput cup 2 0 && printf '\e[2k' && printf '\e[32m%s\e[0m\n' "  Yes"
        tput cup 3 0 && printf '\e[2k' && printf '\e[31m%s\e[0m\n' "> No"
    fi

        # read no backslashes, silent, 1 key at a time
        case "$key" in
            j|$'\x1b\x5b\x41') if [[ "$index" = 0 ]]; then index=1 ; elif [[ "$index" = 1 ]]; then index=0 ; fi ;;
            k|$'\x1b\x5b\x42') if [[ "$index" = 0 ]]; then index=1 ; elif [[ "$index" = 1 ]]; then index=0 ; fi ;;
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
    stty sane
    echo "$index"
    return "$index"
}

cleanup() {
    # clear
    tput cnorm
    stty echo
}

trap cleanup EXIT

menu "${@}"