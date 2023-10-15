#!/bin/bash

pwd="$(pwd)"
if [ "$pwd" != "$HOME/repos/install-scripts" ]; then
    echo "rsync could be destructive in the wrong directory"
    echo "you are in - $pwd"
    exit 0
fi

rsync --inplace --delete -r --update ~/.config/starhip .
rsync --inplace --delete -r --update ~/.config/helix .
rsync --inplace --delete -r --update ~/.config/zsh .

\cp ~/.zshrc .
\cp ~/.zshenv .
