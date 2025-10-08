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
alias gst="gs stack"
alias gssr="gs stack restack"
alias gsss="gs stack submit"

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias kgi='kubectl get ingress'
alias kgc='kubectl get configmap'
alias kdp='kubectl describe pod'
alias kdn='kubectl describe node'
alias kds='kubectl describe service'
alias kl='kubectl logs'
alias kgpa='kubectl get pods --all-namespaces'
alias kgda='kubectl get deployments --all-namespaces'
alias kgn='kubectl get nodes'
alias kdn='kubectl describe node'
alias kctx='kubectx'

alias util='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''

alias cpualloc='util | grep % | awk '\''{print $1}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*20), "%\n" } }'\'''
alias memalloc='util | grep % | awk '\''{print $5}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*75), "%\n" } }'\'''
