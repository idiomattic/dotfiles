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

# Aliases
alias ls='ls --color'
alias gcd='git checkout develop'
alias gcm='git checkout master'
alias grelease="git push origin develop --tags && git checkout master && git push origin master && git checkout develop"

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

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# ENV VARS
export SEARCH_VIS_API_KEY_PROD="NsteGWN6bwGj3CbuZTiWPXegRdXHkoLxrU4FG82ag29fnVD2"
export SEARCH_VIS_API_KEY="vegk78t6ikmzKT9HjF7HTTe8Twr4v36XP2sdxEaQPU26n2BN"
export SEARCH_BOOSTING_TEST_VARIANT="gEbnJ3By89vQ"
export SEARCH_RANK_V1_TEST_VARIANT="pBZr2dXH6t4i"
export SEARCH_RANK_V2_TEST_VARIANT="8qXWCTFX7QPG"
export SEARCH_RANK_V3_TEST_VARIANT="hJscCQaGsE7x"
export SEARCH_MAX_HITS_EXPANDED="1000"
export SEARCH_ILB_IP="10.138.0.66"
export SEARCH_EXPERIMENT_ILB_IP="10.138.0.67"
export SEARCH_ILB_IP_DATA_ES="10.138.1.41"
export SEARCH_METRICS_BY_LISTING_KEYWORD="gs://ps-prod-search-csv/search_metrics_by_listing_keyword.csv"
export KEYWORD_TAXONOMY="gs://ps-prod-cluster/output_airflow/prod/search/keyword_taxonomy.csv"
export LISTING_METRICS="gs://ps-prod-search-csv/listing_metrics.csv"
