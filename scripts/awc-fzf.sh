#!/bin/bash
SHELL=/usr/bin/bash
mainf() {
    kitty --hold --class=spad zsh -c fzf-ubz.sh ; zsh
}
export mainf

awesome-client '                                                                                                                                                     
             awful = require("awful")
             awful.spawn("alacritty --class spad -e zsh -c fzf-ubz.sh")
           '
