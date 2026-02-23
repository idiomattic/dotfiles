help() {
    "$@" --help 2>&1 | bathelp
}

urldecode() {
  echo -n $1 | python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));"
}

# Git Functions
gitbranchname() {
  git branch --show-current | tr -d "\n"
}

gbdelete() {
  feature_branch=$(gitbranchname)
  if [[ $feature_branch != "develop" && $feature_branch != "master" ]]; then
    git checkout develop
    git pull origin develop
    git branch -D "$feature_branch"
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

backup() {
  local og_file="$1"
  local base="${og_file}.$(date +%F)"
  local dest="$base"
  local i=1

  while [[ -e "$dest" ]]; do
    dest="${base}.${i}"
    ((i++))
  done

  cp "$og_file" "$dest"
  echo "Backed up to: $dest"
}
