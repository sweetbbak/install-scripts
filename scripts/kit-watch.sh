#!/bin/bash

# watch ctrl
# kitty @ launch --os-window-class=spad --type=os-window --title spad --keep-focus --location=vsplit 
kitty @ launch --type=window --title fzimg --keep-focus --location=split 

# kitty @ send-text -m "not state:focused" "kitty +kitten icat ~/Pictures/anime-icons/* \r"
# kitty @ send-text -m "title:^Picts"
# this closes both lol
# --bind 'enter:execute(kitty @ close-tab --match "not state:focused and state:parent_focused")+abort'

# ez pz
fd . ~/Pictures -e png -e jpg | \
    fzf --cycle \
        --border=rounded \
        --bind "left:execute()" \
        --bind "right:execute()" \
        --preview 'kitty @ send-text -m "not state:focused" "kitty +kitten icat --clear --scale-up --place 55x55@0x0 {} \r"' \
        --bind 'enter:execute(echo {} > /dev/tty && kitty @ close-window -m "title:^fzimg")+abort'
