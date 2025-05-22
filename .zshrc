. /opt/homebrew/opt/asdf/libexec/asdf.sh
. ~/.asdf/plugins/golang/set-env.zsh

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
        cd "configs/$env/encrypted" && pskms -c "$env" -e -f service-keys.env && cd ../../..
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

# Add prompt command to path
# Remove any existing prompt_engineer entries from PATH
PATH=$(echo $PATH | tr ':' '\n' | grep -v "$HOME/prompt_engineer" | tr '\n' ':' | sed 's/:$//')

# Add prompt_engineer to PATH if it's not already there
if [[ ":$PATH:" != *":$HOME/prompt_engineer:"* ]]; then
  export PATH="$PATH:$HOME/prompt_engineer"
fi

export PROMPTS_DIR="$HOME/prompt_engineer"

convert_to_txt() {
    local input_dir=""
    local output_dir=""
    local extension_filter=""
    local show_help=false

    show_usage() {
        echo "Usage: convert_all_to_txt [OPTIONS]"
        echo ""
        echo "Convert files to .txt extension while respecting git ignore rules."
        echo ""
        echo "Options:"
        echo "  -i, --input PATH      Input directory (required)"
        echo "  -o, --output PATH     Output directory (required)"
        echo "  -e, --extension EXT   Filter by file extension (e.g., 'py', '.js')"
        echo "  -h, --help           Show this help message"
        echo ""
        echo "Examples:"
        echo "  convert_all_to_txt -i /path/to/source -o /path/to/dest"
        echo "  convert_all_to_txt --input ./src --output ./txt --extension py"
        echo "  convert_all_to_txt -i . -o ../output -e .js"
    }

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i|--input)
                if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                    input_dir="$2"
                    shift 2
                else
                    echo "Error: --input requires a path argument"
                    return 1
                fi
                ;;
            -o|--output)
                if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                    output_dir="$2"
                    shift 2
                else
                    echo "Error: --output requires a path argument"
                    return 1
                fi
                ;;
            -e|--extension)
                if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                    extension_filter="$2"
                    shift 2
                else
                    echo "Error: --extension requires an extension argument"
                    return 1
                fi
                ;;
            -h|--help)
                show_help=true
                shift
                ;;
            *)
                echo "Error: Unknown option: $1"
                echo "Use -h or --help for usage information"
                return 1
                ;;
        esac
    done

    if [[ "$show_help" == true ]]; then
        show_usage
        return 0
    fi

    if [[ -z "$input_dir" ]]; then
        echo "Error: Input directory is required"
        echo "Use -h or --help for usage information"
        return 1
    fi

    if [[ -z "$output_dir" ]]; then
        echo "Error: Output directory is required"
        echo "Use -h or --help for usage information"
        return 1
    fi

    if [ ! -d "$input_dir" ]; then
        echo "Error: Input directory '$input_dir' does not exist"
        return 1
    fi

    if [ ! -d "$output_dir" ]; then
        mkdir -p "$output_dir"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create output directory '$output_dir'"
            return 1
        fi
    fi

    if [ -n "$extension_filter" ]; then
        extension_filter="${extension_filter#.}"
        extension_filter=".$extension_filter"
        echo "Filtering for files with extension: $extension_filter"
    fi

    matches_extension() {
        local file="$1"
        if [ -z "$extension_filter" ]; then
            return 0
        fi
        [[ "$file" == *"$extension_filter" ]]
    }

    local original_pwd="$(pwd)"
    cd "$input_dir" || return 1

    if ! command -v git >/dev/null 2>&1 || ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "Note: Not in a git repository or git not available, processing all files"
        find . -type f | while read -r file; do
            file="${file#./}"

            if ! matches_extension "$file"; then
                continue
            fi

            local full_file_path="$input_dir/$file"
            local output_filename_stem_dots="${file//\//.}"
            local final_output_filename_txt="${output_filename_stem_dots}.txt"
            local target_file_full_path="$output_dir/$final_output_filename_txt"

            cp "$full_file_path" "$target_file_full_path"
            if [ $? -eq 0 ]; then
                echo "Converted: $file -> $target_file_full_path"
            else
                echo "Error: Failed to convert $file"
            fi
        done
    else
        git ls-files --cached --others --exclude-standard | while read -r file; do
            if [ -f "$file" ] && matches_extension "$file"; then
                local full_file_path="$input_dir/$file"
                local output_filename_stem_dots="${file//\//.}"
                local final_output_filename_txt="${output_filename_stem_dots}.txt"
                local target_file_full_path="$output_dir/$final_output_filename_txt"

                cp "$full_file_path" "$target_file_full_path"
                if [ $? -eq 0 ]; then
                    echo "Converted: $file -> $target_file_full_path"
                else
                    echo "Error: Failed to convert $file"
                fi
            fi
        done
    fi

    cd "$original_pwd"
}

. "$HOME/.local/bin/env"
eval "$(zoxide init zsh)"
eval "$(/Users/matthewlese/peerspace/dev-env/tools/bin/p init -)"
eval "$(/Users/matthewlese/.local/bin/mise activate zsh)"
