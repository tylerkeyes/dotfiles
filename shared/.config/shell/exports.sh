# Shared environment variables for all POSIX-compatible shells
# This file should contain only environment variable exports

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"

# Default editor
export EDITOR="nvim"

# Eza configuration
export EZA_ICONS_AUTO="always"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

# Fuzzy finder configuration
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude={.git,OrbStack}"

# Package managers and version managers
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Custom bin directories
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ASDF version manager
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# PNPM package manager
export PNPM_HOME="$HOME/Library/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
  export PATH="$PNPM_HOME:$PATH"
fi

# Source personal environment file if it exists
if [ -f "$HOME/.env" ]; then
  . "$HOME/.env"
fi

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  export TERM=xterm-256color
fi
