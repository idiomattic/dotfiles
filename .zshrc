# Uncomment to enable profiling - for debugging which parts of profile loading are taking the longest
# zmodload zsh/zprof

# ============================================
# ENVIRONMENT VARIABLES
# ============================================
export EDITOR="code -w"
export PATH="$HOME/.private/bin:$PATH"

# ============================================
# ZINIT SETUP (Plugin Manager)
# ============================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# ============================================
# ZSH CONFIGURATION
# ============================================
# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ============================================
# PLUGINS
# ============================================
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light reegnz/jq-zsh-plugin

# Oh My Zsh snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# ============================================
# CUSTOM FUNCTIONS
# ============================================
[ -f "$HOME/.zsh/functions.zsh" ] && source "$HOME/.zsh/functions.zsh"

# ============================================
# ALIASES
# ============================================
# Git aliases
alias gcd='git checkout develop'
alias gcm='git checkout master'
alias grelease="git push origin develop --tags && git checkout master && git push origin master && git checkout develop"
alias gsubup="git submodule update --init --recursive"
alias lg="lazygit"

# Docker aliases
alias dkillemall='docker kill $(docker ps -qa)'
alias dps='docker ps --format "{{.Names}} {{.Status}}"'

# Development aliases
alias cleanrundev="lein with-profile dev do clean, deps, run -m clojure.main dev/scripts/figwheel.clj"
alias checkport="sudo lsof -i :"
alias killpid="kill -9"

# Tool replacements
alias grep='rg'
alias ls='ls -lh --color'
alias cat='bat'
alias bathelp='bat --plain --language=help'
alias nv="nvim"

# ============================================
# EXTERNAL TOOL INTEGRATIONS
# ============================================
# Homebrew (should be early in the integration chain)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Development environment manager (mise/rtx)
# Only activate here if we're not loading the work init script
if [ ! -f "/Users/matthewlese/peerspace/dev-env/setup/init.sh" ]; then
  eval "$(/Users/matthewlese/.local/bin/mise activate zsh)"
fi

# FZF fuzzy finder
eval "$(fzf --zsh)"

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Work-specific setup (conditional - only if file exists)
if [ -f "/Users/matthewlese/peerspace/dev-env/setup/init.sh" ]; then
  source /Users/matthewlese/peerspace/dev-env/setup/init.sh
fi

# Additional environment sources
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Atuin (shell history)
if [ -f "$HOME/.atuin/bin/env" ]; then
  . "$HOME/.atuin/bin/env"
  eval "$(atuin init zsh)"
fi

# ============================================
# PROMPT (Must be LAST)
# ============================================
eval "$(starship init zsh)"

# Uncomment to enable profiling - for debugging which parts of profile loading are taking the longest
# zprof
