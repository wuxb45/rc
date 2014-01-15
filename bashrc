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
alias grc='grep -nr --include=*.{cc,c,h,cpp,cxx,C,py,hs,java,sh,pl}'
alias df='df -h'
alias du0='du -h --max-depth=0'
alias du1='du -h --max-depth=1'
alias free='free -h'
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

# pdfgrep: find pdfs and grep text {{{
pdfgrep()
{
  pat="$1"
  IFS=$'\n'
  for pdf in $(find . -iname '*.pdf'); do
    echo -ne "--> \033[K${pdf}\r"
    pdftotext "${pdf}" - 2>/dev/null | grep -nEH --color=auto --label="${pdf}" "${pat}" -
  done
}
# }}}

# pdfsplit: split pages from pdf {{{
pdfsplit()
{
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=${1} -dLastPage=${2} \
       -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf ${3}
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
  if [ $# -gt 0 ]; then
    echo "$1" >> ~/.dict_history
    dict "$1" | less
  else
    echo "dict: feed me a word?"
  fi
}
# }}}

# sshtn/sshtnr {{{
# build ssh tunnel at background
sshtn ()
{
  # $# the counts
  # $@/$* the args
  if [ $# -lt 2 ]; then
    echo "usage: sshtn <user@host> <rport> [<lport>] "
    return
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

sshtnr ()
{
  # $# the counts
  # $@/$* the args
  if [ $# -lt 2 ]; then
    echo "usage: sshtnr <user@host> <rport> [<lport>] "
    return
  fi
  local hostname=$1
  local rport=$2
  local lport=$3
  if [ $# -lt 3 ];
  then
    lport=$rport
  fi
  ssh -fNq -R "$rport":localhost:"$lport" "$hostname"
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

# rpush {{{
rpush ()
{
  if [[ $# -lt 2 ]]; then
    echo "usage: rpush <dir-or-file> <target-host>"
    return
  fi
  local fullpath=$(readlink -f "$1")
  local remote=$2
  if [[ -d ${fullpath} ]]; then
    ssh ${remote} "mkdir -p ${fullpath}"
    rsync -av "${fullpath}/" "${remote}:${fullpath}"
  else
    ssh ${remote} "mkdir -p ${fullpath%/*}"
    rsync -v "${fullpath}" "${remote}:${fullpath}"
  fi
}

# }}}

# convert to mp3 {{{
# packages: flac for dec. flac, mac for dec. ape, lame for enc. mp3
# cd-tracker: cdparanoia -B
xmp3 ()
{
  local input=$1
  local ext=${input##*.}
  local lext=${ext,,*}
  if [[ ! -f ${input} ]]; then
    echo "** ${input}: file not exist"
    return
  fi
  if [[ ${ext} == "ape" ]]; then
    mac "${input}" - -d | lame -m j -q 2 -V 0 -s 44.1 --vbr-new - "${input%.*}.mp3"
  elif [[ ${lext} == "flac" ]]; then
    flac -c -d "${input}" | lame -m j -q 2 -V 0 -s 44.1 --vbr-new - "${input%.*}.mp3"
  elif [[ ${lext} == "wav" ]]; then
    lame -m j -q 2 -V 0 -s 44.1 -vbr-new "${input}" "${input%.*}.mp3"
  else
    echo "**What is ${input} ?"
  fi
}

# }}}

# $PS1 {{{
mkdir -m777 -p "/tmp/ps1cache"
# show some files in current dir
ps1_file_hints ()
{
  local hintinfo="/tmp/ps1cache/${USER}.$$.ps1hint"
  local hinttext="/tmp/ps1cache/${USER}.$$.ps1text"
  local last=""
  if [[ -f "${hintinfo}" ]]; then
    last=$(cat "${hintinfo}")
  fi
  local cap=$(($(tput cols) - 15))
  local newhint="$(pwd):${cap}:$(date -Ins -r .)"

  if [[ ${last} == ${newhint} ]]; then
    cat "${hinttext}"
    return
  fi
  echo -n "$newhint" > "${hintinfo}"
  local len='0'
  local text=""
  for x in $(ls -UF | head -n 40); do
    local wc=$(wc -L <<< "$x")
    len=$(($len + $wc + 1))
    if [ $len -gt $cap ]; then
      break
    else
      text+="$x "
    fi
  done
  text+="... $(echo $(ls -U) | wc -w) total"
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

# dummy clean {{{
dummyclean ()
{
  rm -f *.hi *.o *~
}
# }}}

[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local
