. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

alias dkillemall='docker kill $(docker ps -qa)'
alias dps='docker ps --format "{{.Names}} {{.Status}}"'
alias cleanrundev="lein with-profile dev do clean, deps, run -m clojure.main dev/scripts/figwheel.clj"
alias checkport="sudo lsof -i :"
alias killpid="kill -9"

alias grep='rg'
alias ls='ls --color'
alias cat='bat'
alias bathelp='bat --plain --language=help'

alias nv="nvim"

help() {
    "$@" --help 2>&1 | bathelp
}

urldecode() {
  echo -n $1 | python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));"
}

decrypt_secrets() {
    for env in "$@"; do
        cd "configs/$env/encrypted" && pskms -c "$env" -f service-keys.env.encrypted && cd ../../..
    done
}

encrypt_secrets() {
    for env in "$@"; do
        cd "configs/$env/encrypted" && pskms -c "$env" -f service-keys.env && cd ../../..
    done
}

gitbranchname() {
  git branch --show-current | tr -d "\n"
}

gbdelete() {
  feature_branch=$(gitbranchname)

  if [[ $feature_branch != "develop" && $feature_branch != "master" ]]; then
    git checkout develop

    git pull origin develop

    git branch -D "$feature_branch"

    # echo "Pulled the latest changes from 'develop' and deleted local feature branch '$feature_branch'."
  else
    echo "You are currently on the 'develop' or 'master' branch. No action performed."
  fi
}

gbcopy() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    branch_name=$(gitbranchname)
    pbcopy <<< "$branch_name"
    echo "'$branch_name' copied to clipboard"
  else
    echo "Not in a Git repository"
    return 1
  fi
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

prodVPNOTP() {
	op read "op://Private/ps-prod-openvpn01 VPN credentials/one-time password?attribute=otp"
}
cpvpncode() {
  prodVPNOTP | pbcopy
}


update_tags() {
    if [ $# -lt 3 ]; then
        echo "Usage: update_tag_multi <service> <new_tag> <cluster1> [cluster2 ...]"
        return 1
    fi

    local CLUSTER_CONFIGS_BASE_PATH="$HOME/peerspace/cluster-configs"
    local service="$1"
    local new_tag="$2"
    shift 2

    local clusters=("$@")

    for cluster in "${clusters[@]}"; do
        local config_file="${CLUSTER_CONFIGS_BASE_PATH}/configs/${cluster}/ps-services.yaml"

        if [ ! -f "$config_file" ]; then
            echo "Error: Config file not found: $config_file"
            return 1
        fi

        sed -i '' "/- source: services\/${service}.yaml/,/special_env:/s/image_tag:.*/image_tag: ${new_tag}/" "$config_file"

        if [ $? -eq 0 ]; then
            echo "Changes for $service in $cluster:"
            git diff "$config_file"
        else
            echo "Error: Failed to update image_tag"
            return 1
        fi
    done
}
