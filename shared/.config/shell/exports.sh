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
export GOENV_ROOT="${GOENV_ROOT:-$HOME/.goenv}"
export PATH="${GOENV_ROOT}/bin:${GOENV_ROOT}/shims:${PATH}"
# Run goenv init eagerly — lazy-loading breaks subprocesses (gopls, etc.)
# because they inherit the environment but never trigger the lazy loader.
if command -v goenv >/dev/null 2>&1; then
  eval "$(goenv init -)"
fi

# ASDF version manager
export PATH="$PATH:${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

# Custom bin directories
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"

# Package managers and version managers
export PATH="$PATH:$HOME/.bun/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/opt/homebrew/bin"

# PNPM package manager
export PNPM_HOME="$HOME/Library/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
  export PATH="$PATH:$PNPM_HOME"
fi

# Source personal environment file if it exists
if [ -f "$HOME/.env" ]; then
  . "$HOME/.env"
fi

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  export TERM=xterm-256color
fi

# Docker/Colima configuration
export COLIMA_HOME="$HOME/.config/colima"
export DOCKER_HOST="unix://$COLIMA_HOME/default/docker.sock"
