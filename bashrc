#
# ~/.bashrc
#
# vim: fdm=marker

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias {{{
alias vi='vim'
alias ls='ls --color=auto'
alias ll='ls -alhF --time-style=long-iso'
alias la='ls -A'
alias l='ls -CF'
alias tree='tree -C'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gr='grep -nr'
alias df='df -h'
alias du0='du -h --max-depth=0'
alias du1='du -h --max-depth=1'
#     update id3 for mp3 files
alias mp3chinese='find . -iname "*.mp3" -execdir mid3iconv -e gbk --remove-v1 {} \;'
#     haskell file server
alias hfsup='killall hfs; nohup hfs &>/dev/null &'
# }}}

# dict {{{
# search dictionary and remember history
function d ()
{
  if [ $# -gt 0 ];
  then
    echo "$1" >> ~/.dict_history
    dict "$1"
  fi
}
# }}}

# sshtn {{{
# build ssh tunnel at background
function sshtn ()
{
  # $# the counts
  # $@/$* the args
  if [ $# -lt 2 ];
  then echo "usage: sshtn <user@host> <rport> [<lport>] "; return
  fi
  local hostname=$1
  local rport=$2
  local lport=$3
  if [ $# -lt 3 ];
  then
    lport=$rport
  fi
  ssh -f -N -q -L "$lport":localhost:"$rport" "$hostname"
}
# }}}

# rbackup {{{
# backup using rsync
function rbackup ()
{
  local target="$HOME"/backup"$(pwd)"/
  mkdir -p $target && rsync -av . $target
}
# }}}

# PS1 {{{
# show some files in current dir
function ps1_file_hints ()
{
  local cap=$(($(tput cols) - 15))
  local len='0'
  for x in $(ls -F); do
    local wc=${#x}
    len=$(($len + $wc + 1))
    if [ $len -gt $cap ]; then
      echo -n "... $(echo $(ls) | wc -w) total"
      return
    else
      echo -n "$x "
    fi
    i=$(($i+1))
  done
  echo -n "... $(echo $(ls) | wc -w) total"
}

function ps1_pwd_info ()
{
  echo $(ls -dlhF --time-style=long-iso) | tr -s ' ' | cut -d' ' -f1,3,4,6,7
}

PS1='\[\033[01;31m\u\]\[\033[01;36m@\]\[\033[01;35m\h\]\[\033[01;36m@\]\[\e[32;1m\t\]\[\033[01;00m\]:\[\033[01;34m\]\w\[\033[00m\] ($(ps1_pwd_info))\n($(ps1_file_hints))\n\$ '
# }}}

function vv ()
{
  if [ $# -lt 1 ]; then
    return
  fi
  xdg-open "$1" &>/dev/null
}

# $PATH {{{
CABALBIN=$HOME/.cabal/bin
if [ -d "$CABALBIN" ]; then
  export "PATH=$CABALBIN:$PATH"
fi

PROGRAMDIR=$HOME/program
if [ -d "$PROGRAMDIR" ]; then
  for prog in $(ls $PROGRAMDIR); do
    export "PATH=$PROGRAMDIR/$prog/bin:$PATH"
  done
fi
# }}}

# misc {{{
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTIGNORE='&'
export EDITOR='vim'
export LD_LIBRARY_PATH=/opt/lib

shopt -s cdspell checkwinsize no_empty_cmd_completion
# }}}
