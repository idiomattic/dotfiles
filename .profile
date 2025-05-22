
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# . "$HOME/.cargo/env"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

. "$HOME/.local/bin/env"

if [[ "${SECRETS_LOADED}" == "" ]] ; then
  eval $(op --account=ps-team.1password.com inject -i ~/.private/1p-secrets.sh | grep -Ev '^#')
  # configure auth for NPM
  if [[ -n "${NPM_TOKEN}" ]] ; then
    echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" >~/.npmrc
  fi
fi
