#!/bin/bash
printf "\033c"
    echo ""
    { for i in {16..51} {51..16}; do echo -en "\e[38;5;${i}m#\e[0m"; done; echo; }
    echo ""
    for line in "$@"; do
        echo -e '\e[38;5;82m' "$line"
    done
    echo ""
    { for i in {16..51} {51..16}; do echo -en "\e[38;5;${i}m#\e[0m"; done; echo; }
    echo ""
    tput sgr0