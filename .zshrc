# shellcheck disable=SC2016,SC2296
export EDITOR='helix'
export VISUAL='kitty helix'
export SHELL=/bin/bash
export HISTFILE=~/.config/zsh/zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export MANPAGER="bat --color=always -p -l man"
# export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat --color=always -p -l man'"
export PAGER='bat --color=always'
export MANPAGER='bat -p -l man'
export DIFFPROG="nvim -d"

# dotbare
export DOTBARE_DIR="$HOME/.dotfiles"
export DOTBARE_TREE="$HOME"
export DOTBARE_PREVIEW="bat -n {}"
export DOTBARE_BACKUP="/home/sweet/hdd/dots-backup"

# --- uncomment your theme ---
STARSHIP_THEME="$HOME/.config/starship/starship.toml"
# STARSHIP_THEME="$HOME/.config/starship/material.toml"
# ---------------------------

# lessfilter / lesspipe
eval "$(lesspipe.sh)"
LESSOPEN="|$HOME/.lessfilter %s"
export LESSOPEN

function _git-diff {
zle edit-command-line
zle .kill-whole-line
zle -U "nf
$CUTBUFFER"
}

zle -N _git-diff
bindkey '^X' _git-diff

alias tts1="piper-tts --model ~/ssd/model_1/model.onnx --output_raw | aplay -r 22050 -c 1 -f S16_LE -t raw"
alias tts="piper-tts --model ~/ssd/amy/amy.onnx --output_raw | aplay -r 22050 -c 1 -f S16_LE -t raw"

function __source() {
  # shellcheck source=/dev/null
  [ -f "$1" ] && source "$1"
}

# --- Okolors ---
# shellcheck source=/dev/null
__source "$HOME/.cache/okolors/colors.sh"

# --- Pywal ---
__source "$HOME/.cache/wal/colors.sh"

# tab sources for better completion
zstyle ':autocomplete:*' default-context history-incremental-search-backward
__source "$HOME/.config/zsh/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh"

# fzf-tab sources for easier hands off config
# __source ~/.config/zsh/plugins/fzf-tab-source/*.zsh

# must be sourced before compinit
comp_gen="$HOME/.config/zsh/zsh-completion-generator/zsh-completion-generator.plugin.zsh"
__source "${comp_gen}"
# GENCOMPL_FPATH=$HOME/.zsh/complete
# zstyle :plugin:zsh-completion-generator programs   ggrep tr cat - add programs
# or type gencomp <cmd>

# Starship
STARSHIP_ON=1
export STARSHIP_CONFIG="$STARSHIP_THEME"

if command -v starship >/dev/null && [ "$STARSHIP_ON" -eq 1 ]; then
  eval "$(starship init zsh)"
else
  # fallback prompt
  echo -e "\e[33;3mWelcome $USER\e[0m"
  PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
  RPROMPT='%*'
  export PROMPT RPROMPT
fi

# --- Keys ---
bindkey '^[[1;5C' forward-word     # ctrl + ->
bindkey '^[[1;5D' backward-word    # ctrl + <-
bindkey '^H' backward-kill-word    # ctrl+backspace delete word
bindkey ' ' magic-space

# file rename magick
bindkey "^[m" copy-prev-shell-word

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
zstyle ':fzf-tab:completion:ouch*' fzf

# disable preview for command options
zstyle ':fzf-tab:complete:*:options' fzf-preview 
# disable preview for subcommands
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
# --- fzf-tab-opts ---
# the format is:
# zstyle ':fzf-tab:{context}' tag value.
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd - USE SINGLE QUOTES
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:ls:*' fzf-preview "cat -p {}"
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# disable sort when completing options of any command
# zstyle ':completion:complete:*:options' sort false
# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# use lessfilter
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'

# env vars
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# git completion
# it is an example. you can change it
# zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
# 	'git diff $word | delta'
# zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
# 	'git log --color=always $word'
# zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
# 	'git help $word | bat -plman --color=always'
# zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
# 	'case "$group" in
# 	"commit tag") git show --color=always $word ;;
# 	*) git show --color=always $word | delta ;;
# 	esac'
# zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
# 	'case "$group" in
# 	"modified file") git diff $word | delta ;;
# 	"recent commit object name") git show --color=always $word | delta ;;
# 	*) git log --color=always $word ;;
# 	esac'

# # tldr
# zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
# # commands
# zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
# ¦ '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# # completion for man edge cases
# zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
# zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

# enable tmux pop up instead of regular fzf.
#zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# History configurations
setopt autocd
setopt hist_ignore_space         # ignore commands that start with space
setopt interactivecomments       # allow comments in interactive mode
setopt numericglobsort           # sort filenames numerically when it makes sense

setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.

# zsh history
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY



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
bindkey '^Z' undo                                 # shift + tab undo last action
# bindkey '^[[Z' undo                             # shift + tab undo last action

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# press Ctrl + V to open fzf-cd zoxide
function _zcd {
zle edit-command-line
zle .kill-whole-line
zle -U "zi
$CUTBUFFER"
}

zle -N _zcd
bindkey '^v' _zcd

# --- Sources -----------------------
# source aliases and personal scripts
# aliases
__source "$HOME/.config/zsh/alias.zsh"

# personal functions
__source "$HOME/.config/zsh/functions.zsh"

# default fzf options
__source "$HOME/.config/zsh/fzf.zsh"

# --- fzf tab ---
__source "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

__source "$HOME/.config/zsh/plugins/fzf-history/zsh-fzf-history-search.zsh"

# auto color cmd output with regex (pretty color output for ping - ps - etc...)
# install grc - pacman -S grc
__source /etc/grc.zsh

# __source ~/.config/zsh/plugins/colored-man.zsh
# __source "$HOME/.config/zsh/zplugs/dirhistory/dirhistory.plugin.zsh"

# source auto suggestions
__source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# dotbare
# __source "$HOME/repos/dotbare/dotbare.plugin.zsh"

# forgit
# __source "$HOME/.config/zsh/plugins/forgit/forgit.plugin.zsh"

#--- interesting auto-complete opts ---
# ZSH_AUTOSUGGEST_STRATEGY=(history)
# Remove forward-char widgets from ACCEPT
# ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
# Add forward-char widgets to PARTIAL_ACCEPT
# ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)

# ---------------------------------
# Syntax highlighting must be loaded last
__source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
