#!/bin/bash
# set up zsh environment
clear
echo -e "\e[31m ________    _____   ______       __    __     __    __   __     __  " 
echo -e "\e[31m(___  ___)  / ___/  (   __ \      \ \  / /     ) )  ( (  (_ \   / _) " 
echo -e "\e[96m    ) )    ( (__     ) (__) )     () \/ ()    ( (    ) )   \ \_/ /   " 
echo -e "\e[96m   ( (      ) __)   (    __/      / _  _ \     ) )  ( (     \   /   "  
echo -e "\e[94m    ) )    ( (       ) \ \  _    / / \/ \ \   ( (    ) )    / _ \    " 
echo -e "\e[94m   ( (      \ \___  ( ( \ \_))  /_/      \_\   ) \__/ (   _/ / \ \_  " 
echo -e "\e[92m   /__\      \____\  )_) \__/  (/          \)  \______/  (__/   \__)" 
echo -e "\n"
echo -e " \e[1;91m Github\e[96m |\e[1;93m sweetbbak"  
echo -e " \e[1;91m xxxxxx\e[1;96m |\e[1;92m sweet"    
echo ""
sleep 1
clear

red='\e[38;5;1m'
green='\e[38;5;2m'
na='\e[0m'

mkdir -p ~/.config/zsh
mkdir -p ~/.config/zsh/plugins
mkdir -p ~/github

mv ./zsh ~/.config
mv ./helix ~/.config
mv ./starship ~/.config
mv ./ranger ~/.config
mv ./bin ~

termux-change-repo
termux-setup-storage

# base ZSH functionality
git clone https://github.com/Aloxaf/fzf-tab "$HOME/.config/zsh/plugins/fzf-tab"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/joshskidmore/zsh-fzf-history-search.git ~/.config/zsh/plugins/fzf-history
git clone https://github.com/Freed-Wu/fzf-tab-source.git "$HOME/.config/zsh/plugins/fzf-tab-source"

# styling
git clone https://github.com/adi1090x/termux-style.git ~/termux-style

mkdir -p ~/.termux/
cd ~/.termux && wget https://github.com/subframe7536/maple-font/releases/download/v6.3/MapleMono-SC-NF.zip
cd || exit

# change default shell to ZSH
# user="$(id -u --name)"
# chsh -s zsh "${user}" >/dev/null

apt_installs=(
    nala
    exa
    bat
    zoxide
    fzf
    starship
    helix
    termux-api
    pup
    mpv
    gum
    jq
    htop
    python
    fd
    python-cryptography
    root-repo
    tsu
    rust
    mpv-android
    ranger
    ani-cli
)

pips=(
    pipx
)

pipxs=(
    yt-dlp
)

for x in "${apt_installs[@]}"; do
    if ! command -v "$x" >/dev/null; then
        pkg install "$x"
        printf "installing ${green}${x}${na}\n"
    else
        printf "${red}${x}${na} already installed\n"
    fi
done

# for x in "${pips[@]}"; do
#     if ! command -v "$x" >/dev/null; then
#         pip install "$x"
#         printf "installing: ${green}${x}${na}\n"
#     else
#         printf "${red}${x}${na} already installed\n"
#     fi
# done

# for x in "${pipxs[@]}"; do
#     if ! command -v "$x" >/dev/null; then
#         pipx install "$x"
#         printf "installing: ${green}${x}${na}\n"
#     else
#         printf "${red}${x}${na} already installed\n"
#     fi
# done
