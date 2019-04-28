
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export NODE_OPTIONS=--max-old-space-size=4096

findandkill() {
    port=$(lsof -n -i4TCP:$1 | grep LISTEN | awk '{ print $2 }')
    if [[ ! -z "${port// }" ]]
    then
        echo pid:$port
        kill -n 9 $port    
    fi 
}
alias killport=findandkill

source ~/.git-completion.bash

if type __git_complete &> /dev/null; then
  _branch () {
    delete="${words[1]}"
    if [ "$delete" == "-d" ] || [ "$delete" == "-D" ]; then
      _git_branch
    else
      _git_checkout
    fi
  }

  __git_complete branch _branch
  __git_complete merge _git_merge
fi;

parse_git_branch() {
  ref=$(git symbolic-ref -q HEAD 2> /dev/null) || return
  printf "${1:-(%s)}" "${ref#refs/heads/}"
}

pimp_prompt() {
  local        BLUE="\[\033[0;34m\]"
  local   BLUE_BOLD="\[\033[1;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[0;37m\]"
  local  WHITE_BOLD="\[\033[1;37m\]"  
  local  LIGHT_GRAY="\[\033[0;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
PS1="${TITLEBAR}$WHITE\w$GREEN\$(parse_git_branch)$WHITE\$ "
PS2='> '
PS4='+ '
}
pimp_prompt
