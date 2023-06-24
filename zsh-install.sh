#!/bin/bash
# set up zsh environment

mkdir -p ~/.config/zsh
mkdir -p ~/github

git clone https://github.com/Aloxaf/fzf-tab ~/github/fzf-tab
git clone https://github.com/joshskidmore/zsh-fzf-history-search.git ~/.config/zsh/fzf-history
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source /data/data/com.termux/files/home/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /data/data/com.termux/files/home/.zshrcgit clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh/plugins/zsh-autocomplete
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/Mononoki.zip
wget https://github.com/subframe7536/maple-font/releases/download/v6.3/MapleMono-SC-NF.zip




export EDITOR='helix'
export SHELL=/bin/bash
# export PATH="$PATH:/usr/bin/python.311"

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
export HISTDUP=erase

export VISUAL='kitty helix'
# export PAGER='less -R'
export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -p -l man'"
export PAGER='bat --color=always'
export DIFFPROG="nvim -d"
export DOTBARE_DIR="$HOME/.dotfiles"
export DOTBARE_TREE="$HOME"
export DOTBARE_PREVIEW="bat -n {}"
export DOTBARE_BACKUP="/run/media/sweet/Hard Drive/linux-backups/dotbare"
# PATH=$PATH$( find $HOME/bin/ -type d -printf ":%p" )
# PATH=$PATH$( fd . $HOME/bin/ -t d -d 1 -X printf " %s" {} )
# path+=$( fd . $HOME/bin/ -t d -d 1 -X printf " %s" {} )
# PATH=$PATH$( find $HOME/scripts/ -type d -printf ":%p" ):$PATH

# export BAT_THEME="Catppuccin-mocha"
# LESS_TERMCAP_md=$'\E[01;31m' LESS_TERMCAP_me=$'\E[0m' GROFF_NO_SGR=1
# LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[01;32m'
# LESS_TERMCAP_us=$'\E[04;33m' LESS_TERMCAP_ue=$'\E[0m'

bindkey -s ^a "nvims\n"

# --- fzf tab ---
# shellcheck source=/dev/null
source "$HOME/github/fzf-tab/fzf-tab.plugin.zsh"

# shellcheck source=/dev/null
source "$HOME/.config/zsh/fzf-history/zsh-fzf-history-search.zsh"
zstyle ':autocomplete:*' default-context history-incremental-search-backward

# fzf history
# source ~/github/zsh-autocomp/zsh-autocomplete.plugin.zsh

# Starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# --- Keys ---
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey ' ' magic-space

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

zstyle ':completion:*' fzf-search-display true

# --- fzf-tab-opts ---
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview "exa -1 --color=always $realpath"
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

## tab sources
# source ~/.config/zsh/plugins/fzf-tab-source/*.zsh

# History configurations
setopt autocd
setopt hist_ignore_space      # ignore commands that start with space
setopt share_history         # share command history data
setopt sharehistory
setopt interactivecomments # allow comments in interactive mode
setopt numericglobsort     # sort filenames numerically when it makes sense

setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.

# THIS IS IT LOL THIS WAS WHAT I WAS LOOKING FOR HAHAHA
# match the command in history and search ie: wget ... + up key searches for wget cmds
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# --- Sources ---
# source aliases and personal scripts
# shellcheck source=/dev/null
source "$HOME/.config/zsh/alias.zsh"
# shellcheck source=/dev/null
# source "$HOME/.config/zsh/functions.zsh"
# shellcheck source=/dev/null
source "$HOME/.config/zsh/fzf.zsh"
# shellcheck source=/dev/null
# source "$HOME/.config/zsh/xport.zsh"

# source auto suggestions and syntax highlighting (syntax needs to be last)
# shellcheck source=/dev/null
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# shellcheck source=/dev/null
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#=#############################################
# export PATH="$HOME/.local/bin:$PATH"
