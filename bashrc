#
# ~/.bashrc
#
# vim: fdm=marker

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# simple alias {{{
alias cd..='cd ..'
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
# update id3 for mp3 files
alias mp3chinese='find . -iname "*.mp3" -execdir mid3iconv -e gbk --remove-v1 {} \;'
alias sshpr='ssh -C2fqTnN -D 1984'
# }}}

# find in filename {{{
fd1 ()
{
  if [[ -n $1 ]]; then
    find . -maxdepth 1 -iname "*${1}*"
  fi
}

fd ()
{
  if [[ -n $1 ]]; then
    find . -iname "*${1}*"
  fi
}

# }}}

# hfsup {{{
# haskell file server
hfsup ()
{
  killall hfs &>/dev/null
  nohup hfs &>/dev/null &
}
# }}}

# dict {{{
# search dictionary and remember history
d ()
{
  if [ $# -gt 0 ];
  then
    echo "$1" >> ~/.dict_history
    dict "$1" | less
  fi
}
# }}}

# sshtn {{{
# build ssh tunnel at background
sshtn ()
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
  ssh -fNq -L "$lport":localhost:"$rport" "$hostname"
}
# }}}

# rbackup {{{
# backup using rsync
rbackup ()
{
  local target="$HOME"/backup"$(pwd)"/
  mkdir -p $target && rsync -av . $target
}
# }}}

# $PS1 {{{
# show some files in current dir
ps1_file_hints ()
{
  local hintinfo="/tmp/${USER}.$$.ps1hint"
  local hinttext="/tmp/${USER}.$$.ps1text"
  local last=""
  if [[ -f "${hintinfo}" ]]; then
    last=$(cat "${hintinfo}")
  fi
  local cap=$(($(tput cols) - 15))
  local newhint="$(pwd):${cap}"

  if [[ ${last} == ${newhint} ]]; then
    cat "${hinttext}"
    return
  fi
  echo -n "$newhint" > "${hintinfo}"
  local len='0'
  local text=""
  for x in $(ls -F); do
    local wc=$(wc -L <<< "$x")
    len=$(($len + $wc + 1))
    if [ $len -gt $cap ]; then
      break
    else
      text+="$x "
    fi
  done
  text+="... $(echo $(ls) | wc -w) total"
  echo -n "${text}" > "${hinttext}"
  echo -n "${text}"
}

ps1_pwd_info ()
{
  echo $(ls -dlhF --time-style=long-iso) | tr -s ' ' | cut -d' ' -f1,3,4,6,7
}

PS1='\[\033[01;31m\u\]\[\033[01;36m@\]\[\033[01;35m\h\]\[\033[01;36m@\]\[\e[32;1m\t\]\[\033[01;00m\]:\[\033[01;34m\]\w\[\033[00m\] ($(ps1_pwd_info))\n($(ps1_file_hints))\n\$ '
# }}}

# vv {{{
# open any file
vv ()
{
  if [ $# -lt 1 ]; then
    return
  fi
  xdg-open "$1" &>/dev/null
}
# }}}

# $PATH {{{

# param: list-content, name-to-check
# no match -> 0, match -> 1
blacklist-check ()
{
  local blacklist=$1
  if [ -z "${blacklist}" ]; then
    return 0
  fi
  for black in ${blacklist};
  do
    if [ ${black} == $2 ]; then
      return 1
    fi
  done
  return 0
}

CABALBIN=${HOME}/.cabal/bin
if [ -d "${CABALBIN}" ]; then
  export "PATH=${CABALBIN}:${PATH}"
fi

PROGRAMDIR=${HOME}/program
if [ -f "${PROGRAMDIR}/blacklist" ]; then
  blacklist=$(cat ${PROGRAMDIR}/blacklist)
else
  blacklist=""
fi
if [ -d "${PROGRAMDIR}" ]; then
  for prog in $(ls ${PROGRAMDIR}); do
    progdir=${PROGRAMDIR}/${prog}
    blacklist-check "${blacklist}" "${prog}"
    if [[ -d "${progdir}" && $? -eq 0 ]]; then
      export "PATH=${progdir}/bin:${PATH}"
    fi
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
