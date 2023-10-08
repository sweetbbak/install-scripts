#!/bin/zsh

function fzcd() {
    dir="$(fd -d1 -td | fzf --preview='exa {}')"
    dir=$(realpath "$dir")
    [ -d "$dir" ] && cd "${dir}" || echo "error"
}
