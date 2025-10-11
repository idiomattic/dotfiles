# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light reegnz/jq-zsh-plugin

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

source ~/.zsh/functions.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Set default editory to VSCode
export EDITOR="code -w"

# Aliases
alias gcd='git checkout develop'
alias gcm='git checkout master'
alias grelease="git push origin develop --tags && git checkout master && git push origin master && git checkout develop"
alias gsubup="git submodule update --init --recursive"
alias lg="lazygit"

alias dkillemall='docker kill $(docker ps -qa)'
alias dps='docker ps --format "{{.Names}} {{.Status}}"'
alias cleanrundev="lein with-profile dev do clean, deps, run -m clojure.main dev/scripts/figwheel.clj"
alias checkport="sudo lsof -i :"
alias killpid="kill -9"

alias grep='rg'
alias ls='ls -lh --color'
alias cat='bat'
alias bathelp='bat --plain --language=help'

alias nv="nvim"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.private/bin:$PATH"

. "$HOME/.local/bin/env"
eval "$(zoxide init zsh)"
eval "$(/Users/matthewlese/.local/bin/mise activate zsh)"

if [ -f "/Users/matthewlese/peerspace/dev-env/setup/init.sh" ]; then
  source /Users/matthewlese/peerspace/dev-env/setup/init.sh
fi

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

eval "$(starship init zsh)"
