# Shared aliases for all POSIX-compatible shells

# Navigation and utilities
alias groot="echo 'I am Groot!' && cd \$(git rev-parse --show-toplevel)"
alias lg="env TMPDIR=/tmp lazygit"
alias c="clear"
alias vim="nvim"
alias cat="bat"

# Eza (modern ls replacement) aliases
alias ls="eza"
alias ll="eza -l"
alias la="eza -la"
alias lt="eza --tree"

alias g='git'
alias gf='git fetch -tpP'
alias gpull='git pull'
alias gpush='git push'
alias gpr='git pull --rebase'
alias gc='git commit'
alias gss='git status'
alias ga='git add'
alias gl='git log'
alias gw='git worktree'

# Git-spice workflow aliases
# Branch management
alias gsb="gs branch"
alias gsbc="gs branch checkout"
alias gsbcr="gs branch create"
alias gsbs="gs branch submit"
alias gsbt="gs branch track"

# Commit operations
alias gsc="gs commit"
alias gsca="gs commit amend"
alias gscc="gs commit commit"

# Log viewing
alias gsl="gs log long -a"
alias gsll="gs log long"
alias gsls="gs log short"

# Repository operations
alias gsr="gs repo"
alias gsrs="gs repo sync"

# Stack management
alias gss="gs stack"
alias gssr="gs stack restack"
alias gsss="gs stack submit"
