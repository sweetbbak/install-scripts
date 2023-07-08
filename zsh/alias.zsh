#-----------[Alias]---------------------#
alias hx="hx"
alias hx.="hx ."
alias ff="firefox"
alias zz="zathura"
alias nsxiv="nsxiv -a"
alias v='nvim'
alias nv='nvim'
alias cat='bat'
alias rn="ranger"

# Core utils + replacements
alias ls="exa --icons"
alias ll='exa -Fal'
alias l='exa --long --grid'
# alias lsd="exa -l --group-directories-first"
alias lsa='ls -d -- .*(/)'
alias lsd='ls -d -- .*(.)'

alias e="exa --icons --color=always"
alias ee="exa --icons --color=always -a"
alias tree='exa -a -I .git --tree' # exa is an alternative to ls

alias mv="mv -i"
alias cp="cp -rvn"
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias rd='rm -rI "$(exa -D| fzf --height=20% --preview="exa -l {}")"'
alias cxx='chmod +x "$(rg --files -g "*.sh"|fzf -1 --height=20% --preview-window=hidden)"'

# Utility functions for Core utils
alias srs="fd . $path | fzf --height=33% --preview='bat {}' | xargs bash -c"

alias ag="alias | grep "
alias hg="history 1 | grep"
alias zrc="hx ~/.zshrc && source ~/.zshrc"
alias z='zoxide'

alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'

alias pwz='sudo !!'
alias chx="chmod +x"
alias tsm="transmission-remote"
alias gcl='git clone'

alias fix-perms-dirs="find /home/sweet/bin -type d -exec chmod 774 {} +"
alias fix-perms-files="find /home/sweet/bin -type f -exec chmod 664 {} +"

# fzf
alias fsh='fc -l -n -r 1 | sed -Ee "s/^[[:blank:]]+//" | uniq | fzf | tr -d \\n | xclip -selection c'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Internet
alias wget-links='wget -U "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --no-check-certificate "$1" -q -O - | grep -Po "(?<=href=\")[^^\"]*"'
alias wget-images='wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$1"'

# Etc.
alias vg='hx $(gum filter)'

# Locations
alias down="cd ~/storage/Downloads"
alias pics="cd ~/storage/Pictures"
alias vids="cd ~/storage/Videos"
alias docs="cd ~/storage/Documents"

#Pacman
alias pac="sudo pacman"
alias pacs="sudo pacman -S "
alias pacrm="sudo pacman -R"
alias pacup="sudo pacman -Syu"
# what package owns X file
alias pac-who="pacman -Qo"
alias pacq="pacman -Q | grep"
alias pacls="pacman -Q"
alias pacd="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | bat)'" #lists all installed packages w/a double window TUI using fzf + info panel
alias pacc="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"

#handy shit
alias eip='echo $(curl -s http://ifconfig.me)'
alias px2ansi='python ~/github/px2ansi/px2ansi.py'
alias icat="kitty +kitten icat"
alias zshxc="zsh -ixc : 2>&1 | grep"
alias fzman="echo '' | fzf --preview 'man {q}'"
# alias fzawk='echo "" | fzf --print-query --preview 'echo "a\nb\nc\nd" | awk {q}''

# Programs
alias top="htop"
alias py='python'
alias share='printf $(curl -# "https://oshi.at" -F "f=@$(fd -t f -d 1|fzf)"|sed -nE "s_DL: (.*)_\1_p")|xsel' #share file to file share site
alias fmpv='mpv "$(fzf)"'

# Yt-dlp
alias ytdl='yt-dlp --embed-thumbnail'
alias yta="yt-dlp --embed-thumbnail --embed-metadata -x"
alias download="yt-dlp -x --audio-format --embed-thumbnail --embed-metadata mp3"

# System
alias psa="ps -e | grep -i"
alias sudosys="sudo systemctl"
alias envfz="env | fzf"
alias disks="lsblk --nodes --output NAME,MODEL,SIZE"
alias parts="lsblk --output NAME,LABEL,FSTYPE,MOUNTPOINTS,SIZE,MODEL"

alias fonts='fc-list --format="%{family[0]}\n" | sort|uniq| fzf'
alias paths='sed "s/:/\n/g" <<< $PATH'

# Kitty
alias pix="pixcat resize -w 64 -h 32 -W 512 -H 256 --align center --relative-x -2"
alias kittydiff="git difftool --no-symlinks --dir-diff"

# Curl
alias curluser='curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"'

# nvim stuff
alias nvff="open_with_nvim_filetype nvim"
alias nif="open_with_nvim neovide"
alias niff="open_with_nvim_filetype neovide"
