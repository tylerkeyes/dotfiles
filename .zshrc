# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="kafeitu"

zstyle ':omz:update' mode auto      # update automatically without asking

HISTFILE="$HOME/.zsh_history"
# Display timestamps for each command
HIST_STAMPS="%T %d.%m.%y"

HISTSIZE=10000000
SAVEHIST=10000000

# Ignore these commands in history
HISTORY_IGNORE="(ls|pwd|cd)*"

# Write the history file in the ':start:elapsed;command' format.
setopt EXTENDED_HISTORY

# Do not record an event starting with a space.
setopt HIST_IGNORE_SPACE

# Don't store history commands
setopt HIST_NO_STORE

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    asdf
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
source <(kubectl completion zsh)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
export PATH=$PATH:$(go env GOPATH)/bin
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export BAT_THEME="base16"

alias vim="nvim"
alias vi="nvim"

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
source /Users/tylerkeyes/software/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
