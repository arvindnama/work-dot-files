eval "$(/opt/homebrew/bin/brew shellenv)"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/arvindnama/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)



# Path to your oh-my-zsh installation.
export ZSH="/Users/arvindnama/.oh-my-zsh"

export UPDATE_ZSH_DAYS=1

# antigen init ~/.antigenrc

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.rd/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"


export GOROOT="/usr/local/go"
export PATH="$GOROOT/bin:$PATH"

DEFAULT_USER=$USER
POWERLEVEL9K_HIDE_BRANCH_ICON=false
POWERLEVEL9K_VCS_HIDE_TAGS=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time dir vcs newline)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

ZSH_THEME="powerlevel9k/powerlevel9k"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7,bg=cyan,bold,underline"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

plugins=(
  aliases
  aws
  battery
  brew
  copybuffer
  copyfile
  colored-man-pages
  cp
  docker
  docker-compose
  dotenv
  emoji
  git 
  helm
  terraform
  vim-interaction
  vscode
  zsh-autosuggestions
  zsh-interactive-cd
  zsh-navigation-tools
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# pnpm
export PNPM_HOME="/Users/arvindnama/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# print a new line after each command
precmd() { 
    print "" 
}

alias zshrc='vim ~/.zshrc'
alias sz='source ~/.zshrc; echo "zshrc sourced"'



# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

function z() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _files -/
        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Send '\e[0n' to console input.
            \builtin printf '\e[5n'
        fi

        # Report that the completion was successful, so that we don't fall back
        # to another completion function.
        return 0
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.zshrc):
#
eval "$(zoxide init zsh)"

alias zshrc='vim ~/.zshrc'
alias sz='source ~/.zshrc; echo "zshrc sourced"'

# eza is replacement for ls 
# https://eza.rocks/ (brew install eza)
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# bat replace for cat -> content highlighting etc
# brew install bat
alias cat="bat"

# rigrep => replacement for grep
# https://github.com/BurntSushi/ripgrep 
# brew install rigrep (rg)

# zoxide
# https://github.com/ajeetdsouza/zoxide
# brew install zoxide
alias cd="z"
alias zz="z -"


## VMWARE

export NODE_OPTIONS="--max-old-space-size=8192"
export EDITOR=$(which vi)
export PATH="/usr/local/opt/gettext/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/gettext/lib"
export CPPFLAGS="-I/usr/local/opt/gettext/include"
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/Users/arvindnama/aws-sam-cli:$PATH"
export DOCKER_HOST=unix://$HOME/.rd/docker.sock

export VMC_UI_REGISTRY_USER=csp-auto
export VMC_UI_REGISTRY_PASSWD=0376d3af2440efb9d55dc38fc32794f08cdcd706
export VMC_UI_REGISTRY_URL=vmware-docker-skyscraper-docker.bintray.io

export REGISTRY_USER=fractal-automation-write@vmware
export REGISTRY_PASSWORD=d37419006fcab147fb60dc0b07226555b307a582
export REGISTRY_URL=vmware-docker-fractal-dev-docker.bintray.io

export DIMENSION_REGISTRY_USER=fractal-automation-write@vmware
export DIMENSION_REGISTRY_PASSWORD=d37419006fcab147fb60dc0b07226555b307a582
export DIMENSION_REGISTRY_URL=vmware-docker-fractal-dev-docker.bintray.io


export CHROMIUM_BROWSER_VERSION=113.0.5672.24
export CHROMIUM_BROWSER_CUSTOM_PATH=/Applications/Chromium.app/Contents/MacOS/Chromium
# export USER=gitlab-runner



export CI_COMMIT_AUTHOR="Arvind Nama <anama@vmware.com>"
# export GIT_LAB_TOKEN=m2QAEMo9GmGsQwPXBsS7
export GIT_LAB_TOKEN=qGDMb-pEXv7sxe1JnLdj
export GIT_API_TOKEN=w7UuGfyZ-xs1U8537nyH
# export GITLAB_API_TOKEN=m2QAEMo9GmGsQwPXBsS7
# export GITLAB_API_TOKEN=Qj1GHxx5riQEfp4Fws3G
export GITLAB_API_TOKEN=qGDMb-pEXv7sxe1JnLdj
export AWS_GITLAB_TOKEN_WRITE=m2QAEMo9GmGsQwPXBsS7
export AWS_GITLAB_USER_WRITE=svc.vmc-automation
export FRACTAL_GITLAB_TOKEN_WRITE=Qj1GHxx5riQEfp4Fws3G
export FRACTAL_GITLAB_USER_WRITE=svc.fractal-dev

export ARTIFACTORY_PASSWORD=L40WKNOVpweM
export ARTIFACTORY_TOKEN=cmVmdGtuOjAxOjE3MzIxMjgwNjE6dlU4QVNqTkh2dlc3bmh6YVVPYzFGMDJ5QmxD
export ARTIFACTORY_URL=skyscraper-docker-local.artifactory.eng.vmware.com
export ARTIFACTORY_USER=skyscraper-deployer

export JENKINS_API_TOKEN=ee664e40e88b4a450cc8e2840cc785e3
export JENKINS_USER=bduncan


export SKS_ALPHA_CSP_API_TOKEN=tCck7IIDLrtv7cVbPa2wFq8ESbJ1QQaCHq1u1fjUPIM9l258nJ5cTrJNEbCNGMwk
export ACME_CSP_API_TOKEN=wZsJEkNXGCLYvGuijEICIdVmgU9bKm9Uet8zMw1RpekcZmtyYLNX4i3Rl6o2bBYc
export DBC_PATH=/dbc/sc-dbc1118/arvindnama


# VMC Backend

export SDDCWORKER_OPERATOR_REFRESH_TOKEN="d1mcQ"
export SKS_APP_CONFIG_USER_REFRESH_TOKEN_KEY="d1mcQ"
export SKS_MQ_PASSWORD="91UiiR95v"
export DYNDNS_PASSWD="3F$fG2J"
export SS_ENV="local"
# export LOGZIO_API_TOKEN=<>
export VMC_MON_WAVEFRONT_TOKEN="dcbc"
export DYNDNS_DOMAIN_NEW="vmwarevmc.com"
export SKS_MQ_USERNAME="skyscraper"
export CS_CSP_URL="https://console-stg.cloud.vmware.com"
export CSP_URL="http://localhost:8000"
export SERVER_HOST="0.0.0.0"
export DYNDNS_USER="sks-dev-api"
export SKS_STG_CONFIG_SERVICE_OPERATOR_REFRESH_TOKEN="d1mcQVg0"
export BUNDLE_USER_W_AR_SECRET_KEY_3BA="AhpJdd7Z70"
export AWS_PLY_SECRET_KEY_SHQ="pA07Lk/ffKjbW8a+F1"
export PAYER_USER_W_AR_SECRET_KEY_3BA="ff+AuMG13L0y"
export DYNDNS_DOMAIN="vmc.vmware.com"

export SKS_MQ_USERNAME=skyscraper
export SKS_MQ_PASSWORD=91UiiR95vlGK

alias tg="terragrunt"
alias tf="terraform"
alias kc="kubectl"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"


alias dkps="docker ps"
alias dkst="docker stats"
alias dkpsa="docker ps -a"
alias dkimgs="docker images"
alias dkcpup="docker-compose up -d"
alias dkcpdown="docker-compose down"
alias dkcpstart="docker-compose start"
alias dkcpstop="docker-compose stop"
alias dkclean="docker rm -f '$(docker ps -a -q)'  && docker rmi -f '$(docker images -q)'"
alias bintraylogin="docker login -u $REGISTRY_USER -p $REGISTRY_PASSWORD $REGISTRY_URL"
alias skyscraperDockerlogin="docker login -u $ARTIFACTORY_USER -p $ARTIFACTORY_PASSWORD $ARTIFACTORY_URL"
alias vmwaresaasDockerlogin="docker login -u anama -p AKCpBtMeQLeYBZurufSFuVubH4ow6xhtDRJVXqRqBXJgGC3bm8CQwbU4C3KqiptvhR4pvTacv vmwaresaas.jfrog.io"

alias ll="ls -la"
alias lr="ls -laR"
alias chrome='open -a Google\ Chrome --args --disable-web-security --user-data-dir=/Users/arvindnama/chrome/temp'
alias generateTriggerToken='curl --request POST --header "PRIVATE-TOKEN:$GITLAB_API_TOKEN" --form description="E2E triggers" "https://gitlab.eng.vmware.com/api/v4/projects/61857/triggers"'
alias listTriggerToken='curl --request GET --header "PRIVATE-TOKEN:$GITLAB_API_TOKEN" "https://gitlab.eng.vmware.com/api/v4/projects/61857/triggers"'
alias run-vmc-unit-tests='NODE_OPTIONS=--max-old-space-size=8192 pnpm nx run --target=test --code-coverage --browsers=CustomChromeHeadless --watch=true --project='
alias run-many-vmc-unit-tests='NODE_OPTIONS=--max-old-space-size=8192 pnpm nx run-many --target=test --browsers=CustomChromeHeadless --code-coverage --watch=false'
alias run-vmc-unit-tests:chrome='NODE_OPTIONS=--max-old-space-size=8192 pnpm nx test --code-coverage --browsers=CustomChrome --watch=true'
alias run-vmc-unit-tests:no-watch='NODE_OPTIONS=--max-old-space-size=8192 pnpm nx test --code-coverage --browsers=CustomChromeHeadless --watch=false'
alias run-vmc-unit-tests:chrome:no-watch='NODE_OPTIONS=--max-old-space-size=8192 pnpm nx test --code-coverage --browsers=CustomChrome'

export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"



# place this after nvm initialization!
# autoload -U add-zsh-hook

# source-vmc-ui() {
#   if [ -e ./.stg-env.dotfile ]; then 
#     source .stg-env.dotfile
#   fi;
# }

# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"

#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc 
# add-zsh-hook chpwd source-vmc-ui
# load-nvmrc
# source-vmc-ui



# Cloud Gate

export CG_API_CLIENT_ID="OcPCR6LtVUwcQTIkwWSXEgPGviQpumnt"
export CG_API_CLIENT_SECRET="E6xYud7gAK8Rx1K93cIbSiD7VxtdZK3PuBwTOIUwv5ktuSytadHeC/IAIPKbvwKJ"

function jwtd() {
    if [[ -x $(command -v jq) ]]; then
         jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< "${1}"
         echo "Signature: $(echo "${1}" | awk -F'.' '{print $3}')"
    fi
}

function twistlock () {
     sudo FIPS_ENABLED=true ~/twistcli/twistcli images scan --details --address https://twistlock-corp-psco01-stg- gov-psco01-us-gov-west-1.vdp-int-stg.vmware.com --user vmc-autoscaler --password bGV0aW9uIGNvZGUgZm9yI $1
}

cg-aws-token() {
  local role=${2:="PowerUser"}
  local connector="connector:954d2528-49ab-4eae-a7a0-58350dc4f115/container:r-zh17>ou-zh17-gj7rlfp9/id:"
  local accountId=$1
  local resourcePath="${connector}${accountId}"
  
  echo "Role: "$role
  echo "ResourcePath: "$resourcePath
  echo "generating cloud gate token"

  local token=$(curl --location --request POST https://api.console.cloudgate.vmware.com/authn/token \
      --user ${CG_API_CLIENT_ID}:${CG_API_CLIENT_SECRET} \
      --header 'Content-Type: application/json' \
      --data-raw '{ "grant_type": "client_credentials" }' | jq -r '.access_token'
  )
  local session=$(curl 'https://api.console.cloudgate.vmware.com/v2/access/sessions' \
    -H 'authority: api.console.cloudgate.vmware.com' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${token}" \
    --data-raw "{\"resourcePath\":\"${resourcePath}\",\"role\":\"${role}\",\"ttl\":7600}"
  );

 # echo $session

  local accessKeyId=$(jq -r '.credential.accessKeyId' <<< ${session});
  local secretAccessKey=$(jq -r '.credential.secretAccessKey' <<< ${session});
  local sessionToken=$(jq -r '.credential.sessionToken' <<< ${session});

  echo "Updating aws credentials file ~/.aws/credentials"

  echo -e "
  [default]
    aws_access_key_id = ${accessKeyId}
    aws_secret_access_key = ${secretAccessKey}
    aws_session_token = ${sessionToken}
  " > ~/.aws/credentials
}

alias cg-get-dev-token="cg-aws-token '589535178885'"
alias cg-get-stg-token="cg-aws-token '417077651064'"
alias cg-get-dev-pci-token="cg-aws-token '176607635934'"
alias cg-get-ply-pci-token="cg-aws-token '999546760938'"
alias cg-get-stg-pci-token="cg-aws-token '021474185351'"
alias cg-get-prd-pci-token="cg-aws-token '982284856789' 'ReadOnly'"



