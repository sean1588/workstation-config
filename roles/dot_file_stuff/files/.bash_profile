
export WATCHER_RAM_SIZE=4096
export DOCKER_HOST='tcp://watcher0:2376'
export VAULT_ADDR=https://vault.monitoring.ctl.io:8200/
export TEST_URL='https://dev.watcher.ctl.io'
export TEST_USER='testuser.mond'
export TEST_USER_PASSWORD=$(vault read -format=json secret/clc_testuser.mond | jq -r .data.password)
export DOCKER_API_VERSION='1.23'
export TEST_URL='https://dev.watcher.ctl.io'
export EB_TOKEN=$(vault read -format=json secret/elasticbox/tokens/automated_tests | jq -r .data.token)

function set_env_postgres() {
  export AGENT_DB_HOST='local.watcher.ctl.io'
  export AGENT_DB_PORT='5431'
  export AGENT_DB_NAME='agent_api'
  export AGENT_DB_USER='agent_api'
  export AGENT_DB_PASSWORD='doesnotmatter'
  export POSTGRES_PASSWORD='doesnotmatter'
  export CONTAINER_NAME='postgres_test'
  echo 'environment set. make sure to create, migrate, seed.... to run db.'
  echo 'run psql -h local.watcher.ctl.io -p 5431 -U agent_api to access db.'
}

function monhome {
  cd "/Users/sean/project/monitoring/${1}"
  echo "you are here... $(pwd)"
}

function monui {
  monhome mon-ui
}

function moninf {
  monhome mon-infrastructure
}

function monuiv {
  monui
  vim
}

function bk {
 cd ~- 
}

function ksecret {
  kubectl get secrets ${1} -o "go-template={{index .data \"${2}\"}}" | base64 -D -
}

alias uuid="python -c 'import sys,uuid; v4Uuid = uuid.uuid4().urn.replace(\"urn:uuid:\",\"\"); sys.stdout.write(v4Uuid);'| pbcopy && pbpaste && echo"

function display_kubernetes_context() {
      kubectl config get-contexts | grep '^\*' | awk '{print $2}' | tr a-z A-Z
}
PS1_KUBE="${PURPLE} [K8s @ \$(display_kubernetes_context)]\\[\\e[0m\\]"
PS1_TIME="\[\e[33m\][\d \T]"
PS1_PWD="\[\e[36m\]\w"
PS1="\[\e]0;\w\a\]\n\[\e[34m\]Sean @ CTL ${PS1_KUBE} ${PS1_TIME} ${PS1_PWD}\n \[\e[0;0m\] "

# Define some colors:
RED='\[\e[1;31m\]'
BOLDYELLOW='\[\e[1;33m\]'
GREEN='\[\e[0;32m\]'
BLUE='\[\e[1;34m\]'
DARKBROWN='\[\e[1;33m\]'
DARKGRAY='\[\e[1;30m\]'
CUSTOMCOLORMIX='\[\e[1;30m\]'
DARKCUSTOMCOLORMIX='\[\e[1;32m\]'
LIGHTBLUE="\[\033[1;36m\]"
PURPLE='\[\e[1;35m\]' #git branch
NC='\[\e[0m\]' # No Color

# alias rtoken=“vault auth -method github token=\$VAULT_GITHUB_TOKEN”

## Kube Aliases

alias kc=kubectl
alias bex="bundle exec"
alias kcgp="kubectl get pods"
alias kcgpw="kubectl get pods --watch"
alias kcpf="kubectl port-forward"
alias lsa="ls -la"
alias g=git

kubeapp(){
 kubectl get pods -l app=$1 -o name| sed 's@.*/@@'
}
alias ka=kubeapp
function kubeappcon(){
 echo "$(kubeapp ${1}) -c ${1}"
}
alias kac=kubeappcon
function kubeapplog(){
 echo "$(kubeapp ${1}) -c log"
}
alias kal=kubeapplog

function kubelog(){
 kubectl logs -f $(kac ${1})
}
alias klog=kubelog

function kubelogc(){
 kubectl logs -f $(kal ${1})
}

alias klogc=kubelogc

function kubexec(){
  kubectl exec -ti $(kac ${1}) -- bash
}

alias ke=kubexec

function ansible_vault(){
  vault read secret/ansible_vault | awk '{if($1=="password") print $2}' | pbcopy
  echo "secret in clipboard"
}

function rtoken() {
  vault auth -method github token=$VAULT_GITHUB_TOKEN
}

function my_notes() {
  cat "~/.my_notes" | grep "${1}"
}

# iTerm2 configs

# Maximum number of history lines in memory
export HISTSIZE=500000
# Maximum number of history lines on disk
export HISTFILESIZE=500000
# Ignore duplicate lines
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file 
#  instead of overwriting it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# After each command, append to the history file 
#  and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

##### vagrant ssh aliases
##### example: mon_vagrant delete_mnesia
function mon_vagrant(){
  if [[ $(pwd | grep mon-infrastructure) ]]; then
    ${1}
  else
    echo "switch to mon-infrastructure directory to run"
  fi
}
function delete_mnesia() {
  if [[ "$(kubectl config current-context)" = "local" ]]; then
    kubectl scale petset/rabbitmq --replicas=0
    vagrant ssh -c "$(delete_mnesia_cmds)"
    kubectl scale petset/rabbitmq --replicas=2
  else
    echo "please switch to local context - kubectl config use-context local"
  fi
}

function delete_mnesia_cmds(){
  echo "cd /gluster/volumes/local"
  echo "sudo rm -rf rabbitmq-a/mnesia"
  echo "sudo rm -rf rabbitmq-b/mnesia"
}

function sync_ntp(){
  vagrant ssh -c "sudo ntpdate pool.ntp.org"
}


git_gone_branches() {
  git branch -vv | awk '/: gone]/{print $1}'
}

git_clean() {
  git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d
}

export PATH=${PATH}:/Applications/Android\ Studio.app/sdk/platform-tools:/Applications/Android\ Studio.app/sdk/tools

export ANDROID_HOME=/Users/seanholung/Android/adt-bundle-mac-x86_64-20140702/sdk

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH
