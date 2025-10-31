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

# Goenv version manager (must be initialized FIRST before other version managers)
# Initialize goenv to manage Go versions via .go-version files
if command -v goenv >/dev/null 2>&1; then
  eval "$(goenv init -)"
fi

# ASDF version manager
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Custom bin directories
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Package managers and version managers
# Note: Removed /opt/homebrew/bin from this section - use goenv for Go, not brew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

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
