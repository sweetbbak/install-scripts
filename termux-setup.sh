#!/bin/bash
# set up zsh environment

mkdir -p ~/.config/zsh
mkdir -p ~/github

depcheck() {
    for dep; do
        if ! command -v "$dep" >/dev/null; then
            pkg install "$dep"
        else
            return 0
        fi
    done
}

depcheck git

# git clone https://github.com/Aloxaf/fzf-tab ~/github/fzf-tab
# git clone https://github.com/joshskidmore/zsh-fzf-history-search.git ~/.config/zsh/fzf-history
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# echo "source /data/data/com.termux/files/home/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /data/data/com.termux/files/home/.zshrcgit clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# git clone https://github.com/sweetbbak/install-scripts.git

# git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh/plugins/zsh-autocomplete
# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/Mononoki.zip
wget https://github.com/subframe7536/maple-font/releases/download/v6.3/MapleMono-SC-NF.zip
