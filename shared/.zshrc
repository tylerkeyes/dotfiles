# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Source shared aliases and functions
if [ -f "$HOME/.config/shell/aliases.sh" ]; then
  . "$HOME/.config/shell/aliases.sh"
fi

if [ -f "$HOME/.config/shell/functions.sh" ]; then
  . "$HOME/.config/shell/functions.sh"
fi

if [ -f "$HOME/.config/shell/exports.sh" ]; then
  . "$HOME/.config/shell/exports.sh"
fi

# Auto-source profile-specific aliases (aliases.*.sh)
setopt null_glob
for config_file in "$HOME/.config/shell/aliases-"*.sh; do
  if [ -f "$config_file" ]; then
    . "$config_file"
  fi
done

# Auto-source profile-specific functions (functions.*.sh)
for config_file in "$HOME/.config/shell/functions-"*.sh; do
  if [ -f "$config_file" ]; then
    . "$config_file"
  fi
done

# Auto-source profile-specific exports (exports.*.sh)
for config_file in "$HOME/.config/shell/exports-"*.sh; do
  if [ -f "$config_file" ]; then
    . "$config_file"
  fi
done
unsetopt null_glob

# -----------------------------
# Path and Environment
# -----------------------------
# export MANPATH="/usr/local/man:$MANPATH"
# Go path is already handled in shared exports.sh via goenv
export PATH=$PATH:$HOME/software/istio-1.25.0/bin
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export BAT_THEME="base16"
# ASDF shims are already handled in shared exports.sh

# -----------------------------
# Aliases
# -----------------------------
alias vim="nvim"
alias vi="nvim"

# Auto-start tmux if available
# auto_start_tmux

# -----------------------------
# Zinit Setup
# -----------------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
if [[ ! -s $ZINIT_HOME/zinit.git/zinit.zsh ]]; then
  mkdir -p "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/zinit.git" >/dev/null 2>&1
fi

source "$ZINIT_HOME/zinit.git/zinit.zsh"

# -----------------------------
# Plugins
# -----------------------------
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
# Use a cache for completion initialization
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -C
else
  compinit
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
# zinit ice wait lucid; zinit light zsh-users/zsh-completions

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# -----------------------------
# Prompt / Theme
# -----------------------------
eval "$(starship init zsh)"

# -----------------------------
# History Configuration
# -----------------------------
HISTFILE="$HOME/.zsh_history"
HIST_STAMPS="%T %d.%m.%y"
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|pwd|cd)*"
setopt EXTENDED_HISTORY HIST_IGNORE_SPACE HIST_NO_STORE

# -----------------------------
# External Tools
# -----------------------------

# Zoxide smart directory jumping
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

eval "$(atuin init zsh)"
eval "$(fzf --zsh)"

# Kubernetes completion (cached)
if command -v kubectl >/dev/null 2>&1; then
  mkdir -p ~/.zsh_completions
  if [ ! -f ~/.zsh_completions/_kubectl ]; then
    kubectl completion zsh > ~/.zsh_completions/_kubectl
  fi
  fpath+=~/.zsh_completions
fi

source ~/.kuberc
# Added as an alias
# source ~/.gitrc

# -----------------------------
# Envman
# -----------------------------
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# -----------------------------
# NVM (Lazy-loaded)
# -----------------------------
export NVM_DIR="$HOME/.nvm"

# Lazy-load NVM on first use
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Also lazy-load on node/npm/npx invocation
node() {
  unset -f node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  node "$@"
}

npm() {
  unset -f node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npm "$@"
}

npx() {
  unset -f node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npx "$@"
}
