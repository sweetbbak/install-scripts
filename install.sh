#!/bin/bash
# a script to install a wonderful and cozy ZSH shell environment 
# for Arch based distros (EndeavourOS, Arch, SteamOS etc...)
# if you're running this on SteamOS, you can re-run it after an update

# 0 = false
# 1 = true

# backup and replace .zshrc and .zshenv (set to 1 - recommended for first time installation)
zsh_config=1
# pywal but better, highly recommend it for theming
# change this to 1 to install this binary to ~/bin
install_okolors=0
# highly recommend pipx especialy for yt-dlp and such
install_pipx=0
# install custom mpv - allows you to watch videos in the terminal on Kitty
install_mpv=0 ; custom_mpv="https://github.com/dyphire/mpv.git"
# paru is awesome, it helps us install and update packages (likely already installed on SteamOS)
install_paru=0
# pretty package installations (known as ILoveCandy in /etc/pacman.conf)
ILoveCandy=0

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# pretty print
log() {
    printf "\e[32;5;1m%s\e[0m\n" "${@}"
}

install_paru_aur() {
    # method to install paru
    build="$(mktemp -d)"
    cd "${build}" || exit 1
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru || exit 1
    makepkg -si
}

installs=(
    starship
    eza
    paruz
    bat
    ranger
    helix
    kitty
    ani-cli
    neofetch
    rofi
)

extra_installs=(
    rustup
    lutgen
    bash-language-server
    shellcheck
    topgrade
)

disable_readonly() {
    log "Steam read only must be disabled to run the full script..."
    log "It can potentially introduce instability to your system especially if you're a complete beginner..."
    log "Please research before answering yes"
    echo -e ''
    log "Would you like to disable it? (y/n)"
    read -rN1 ask
    case "$ask" in
        Y*|y*) sudo steamos-readonly disable ;;
        N*|n*) echo "" ; log "Okay, moving on without diabling readonly file system. ";;
        *) log "not a recognized answer, goodbye! " && exit ;;
    esac
}

# get the user and OS
user_="$(id -u --name)"
[ -f /etc/os-release ] && _OS="$(grep "^NAME=.*$" < /etc/os-release | sed -e 's/NAME="//g' -e 's/\"//g'  )"
[ ! -f /etc/os-release ] && _OS=""

if command -v termux-change-repo >/dev/null; then
    _OS="Termux"
fi

# arch - an arch based OS will let us do arch specific tasks
declare arch

case "$_OS" in
    *[Ee]ndeavourOS*) arch=1 ;;
    *[Aa]rch*) arch=1 ;;
    *[Mm]anjaro*) arch=1 ;;
    *[Ss]teamOS*) arch=1 ; steam=1 ;;
    *[Tt]ermux*) arch=0 ;;
    *) echo "Unkown OS - it is recommended to only install zsh/mpv/okolors" ; arch=0 ;;
esac

install_paru() {
    # install paru if it doesn't exist AND user allows us to
    if ! command -v paru && [[ "$install_paru" = 1 ]]; then
        sudo pacman -S paru || install_paru_aur
    fi
}

install_base() {
    # install deps and update system
    paru -Syu "${installs[@]}"
}

install_extras() {
    # install deps and update system
    paru -Syu "${extra_installs[@]}"
}

install_zsh() {
    # back up zsh dir if it exists and make our own
    [ -d "$HOME/.config/zsh" ] && log "[ $HOME/.config/zsh ] already exists" && \
    read -r -p "backup zsh folder and reinstall: (y|n) " yes

    case "$yes" in 
        y) mv "$HOME/.config/zsh" "$HOME/.config/zsh.bak" ;;
        n) echo -e "exiting" ; return 1 ;;
    esac

    # create configuration dir
    mkdir -p "$HOME/.config/zsh"
    mkdir -p "$HOME/.config/zsh/plugins"

    # copy custom files into zsh configuration directory
    [ -d ./zsh ] && cp ./zsh/* "$HOME/.config/zsh"

    # download the best plugins known to man
    log "Downloading Fzf-tab completion" ; [ ! -d "$HOME/.config/zsh/plugins/fzf-tab" ] && \
    git clone https://github.com/Aloxaf/fzf-tab "$HOME/.config/zsh/plugins/fzf-tab"

    log "Downloading Zsh syntax highlighting" ; [ ! -d "$HOME/.config/zsh/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.config/zsh/plugins/zsh-syntax-highlighting" || \
    log "this directory already exists, delete and re-run if there are any issues"

    log "Downloading Zsh auto-suggestions" ; [ ! -d "$HOME/.config/zsh/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.config/zsh/plugins/zsh-autosuggestions" || \
    log "this directory already exists, delete and re-run if there are any issues"

    log "Downloading Fzf reverse history search" ; [ ! -d "$HOME/.config/zsh/plugins/fzf-history" ] && \
    git clone https://github.com/joshskidmore/zsh-fzf-history-search.git "$HOME/.config/zsh/plugins/fzf-history" || \
    log "this directory already exists, delete and re-run if there are any issues"

    log "Downloading Fzf tab source files" ; [ ! -d "$HOME/.config/zsh/plugins/fzf-tab-source" ] && \
    git clone https://github.com/Freed-Wu/fzf-tab-source.git "$HOME/.config/zsh/plugins/fzf-tab-source" || \
    log "this directory already exists, delete and re-run if there are any issues"

    # Install ZSHRC file
    if [ "$zsh_config" = 1 ]; then
        [ -f "$HOME/.zshrc" ] && log "[ $HOME/.zshrc ] exists... backing up" \
            && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
        cp ./.zshrc "$HOME/.zshrc" && log "successfully installed .zshenv file"
    fi

    # Install ZSHENV file for adding things to $PATH
    [ -f "$HOME/.zshenv" ] && log "[ $HOME/.zshenv ] exists... backing up" \
        && mv "$HOME/.zshenv" "$HOME/.zshenv.bak"
    cp ./.zshenv "$HOME/.zshenv" && log "successfully installed .zshenv file"
}

cp_configs() {
    [ -d "$HOME/.config/helix" ] && log "[ $HOME/.config/helix ] exists" 
    [ ! -d "$HOME/.config/helix" ] && cp ./helix ~/.config

    [ -d "$HOME/.config/kitty" ] && log "[ $HOME/.config/kitty ] exists"
    [ ! -d "$HOME/.config/kitty" ] && cp ./kitty ~/.config

    [ -d "$HOME/.config/ranger" ] && log "[ $HOME/.config/ranger ] exists"
    [ ! -d "$HOME/.config/ranger" ] && cp ./ranger ~/.config

    [ -d "$HOME/.config/starship" ] && log "[ $HOME/.config/starship ] exists"
    [ ! -d "$HOME/.config/starship" ] && cp ./starship ~/.config

    [ -d "$HOME/bin" ] && log "[ $HOME/bin ] exists"
    [ ! -d "$HOME/bin" ] && cp ./bin "$HOME"

    [ -d "$HOME/scripts" ] && log "[ $HOME/.config/scripts ] exists"
    [ ! -d "$HOME/scripts" ] && cp ./scripts "$HOME"
}

install_okolors() {
    # update Okolors CLI tool
    # basically Pywal but with way better color palettes
    build=$(mktemp -d)
    cd "$build" || exit 1
    wget https://github.com/Ivordir/Okolors/releases/download/v0.3.0/okolors-v0.3.0-x86_64-unknown-linux-gnu.tar.gz
    tar -xvf okolors-v0.3.0-x86_64-unknown-linux-gnu.tar.gz
    \cp ./okolors "$HOME/bin" 
}

# install and build mpv
build_custom_mpv() {
    build=$(mktemp -d)
    cd "$build" || exit 1
    git clone "$1" && cd "$(basename "$_" .git)" || exit 1
    meson setup build
    meson compile -C build
    sudo meson install -C build
    \rm -r "${build}"
}

install_mpv() {
    if command -v git >/dev/null; then
        build_custom_mpv "${custom_mpv}"
    fi
}

install_pipx_stuff() {
    pipx install yt-dlp
}

install_pipx() {
    python3 -m ensurepip
    pip3 install pipx
}

# Add the --c --C pacman animation for updating packages lol its worth it trust me
add_pacman_eye_candy() {
    # [ -f /etc/pacman.conf ] && candy="$(grep "ILoveCandy" < /etc/pacman.conf)"
    [ -f /etc/pacman.conf ] && if ! grep "ILoveCandy" < /etc/pacman.conf
        then echo "ILoveCandy" | sudo tee /etc/pacman.conf >/dev/null
    fi
}

# install pacman candy
if [ "$ILoveCandy" = 1 ]; then
    add_pacman_eye_candy
fi

# install okolors - pywal like app in Rust that slaps so hard
if [ "$install_okolors" = 1 ]; then install_okolors ; fi

# pipx venv manager for isolated python applications
if [ "$install_pipx" = 1 ]; then install_pipx ; fi

# install custom mpv if wanted otherwise install mpv from Arch Repos
if [ "$install_mpv" = 1 ]; then 
    install_mpv && log "Installing MPV... sudo is required" 
else
    if ! command -v mpv >/dev/null; then paru -S mpv; fi
fi

print_help() {
    echo -e "${0##*/} <options>"
    echo -e "\t--mpv\tinstall custom mpv that allows you to watch videos in a kitty terminal"
    echo -e "\t--zsh\tinstall a beautiful zsh configuration"
    echo -e "\t--config\tbackup and install my configuration files"
    echo -e "\t--candy\tadd pacman animation on arch based distros"
    echo -e "\t--all\tinstall it all"
}

printf "%s\e[33;3m %s\e[0m\n" "Hello" "$user_"
printf "%s\e[33;3m %s\e[0m\n" "OS: " "$_OS"
echo -e "This script will install a well rounded base environment for using ZSH and the terminal."

while [ $# -gt 0 ]; do
    case "$1" in
        --mpv) install_mpv ;;
        --zsh) install_zsh ;;
        --config) cp_configs ;;
        --candy) add_pacman_eye_candy ;;
        --all) install_zsh ; install_paru ; install_base ; install_extras;;
        -h|--help) print_help ;;
        *) ;;
    esac
    shift
done