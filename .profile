# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# . "$HOME/.cargo/env"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

. "$HOME/.local/bin/env"

# Load secrets from 1Password
if [[ "${SECRETS_LOADED}" == "" ]] ; then
  eval $(op --account=ps-team.1password.com inject -i ~/.private/1p-secrets.sh | /usr/bin/grep -E -v '^#')
  # configure auth for NPM hosted at Github Package Registry
  if [[ -n "${GITHUB_TOKEN}" ]] ; then
    if [[ ! -e ~/.npmrc ]] ; then
      echo "" > ~/.npmrc
    fi
    echo "@peerspace:registry=https://npm.pkg.github.com" >> ~/.npmrc
    echo "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}" >> ~/.npmrc
  fi
  export SECRETS_LOADED=true
fi

# configure auth for NPM hosted at Github Package Registry
if [[ -n "${GITHUB_TOKEN}" ]] ; then
  echo "@peerspace:registry=https://npm.pkg.github.com" > ~/.npmrc
  echo "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}" >> ~/.npmrc
fi
