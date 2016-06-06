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
alias lt='ls -ltrhF --time-style=long-iso'
alias l='ls -CF'
alias tree='tree -C'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gr='grep -nr'
alias grc='grep -nr --include=*.{cc,hh,c,h,cpp,cxx,C,py,hs,java,sh,pl,tex}'
alias dfh='df -h'
alias du0='du -h --max-depth=0'
alias du1='du -h --max-depth=1'
alias freeh='free -h'
# update id3 for mp3 files
alias mp3chinese='find . -iname "*.mp3" -execdir mid3iconv -e gbk --remove-v1 {} \;'
alias vcheck='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias timestamp='date +%Y-%m-%d-%H-%M-%S-%N'
alias lsb='lsblk -o KNAME,FSTYPE,MOUNTPOINT,MODEL,SIZE,MIN-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,DISC-ZERO'
# }}}

# fd/fd1: find in filename {{{
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

fdh ()
{
  if [[ -n $1 ]]; then
    local gccprefix="/usr/lib/gcc/$(gcc -dumpmachine)/$(gcc -dumpversion)"
    find /usr/include /usr/local/include ${gccprefix}/include ${gccprefix}/include-fixed -iname "*${1}*"
  fi
}
# }}}

# map2pdf: manpages to pdf {{{
man2pdf()
{
  # man2pdf 2 open
  man -t ${1} ${2} | ps2pdf - > ${1}${2}.pdf
}
# }}}

# readmd: read markdown in lynx (by converting to on-the-fly html) {{{
readmd()
{
  markdown ${1} | lynx -stdin
}
# }}}

# pdfgrep: find pdfs and grep text {{{
pdfgrep()
{
  if [[ -z ${1} ]]; then
    echo "usage : pdfgrep <keyword>"
    return
  fi
  local pat="$1"
  for pdf in $(find . -iname '*.pdf'); do
    echo -ne "\033[K=> ${pdf}\r"
    IFS=$'\n' pdftotext "${pdf}" - 2>/dev/null | grep -nEHi --color=auto --label="${pdf}" "${pat}" -
  done
}

pdfgrep1()
{
  if [[ -z ${1} ]]; then
    echo "usage : pdfgrep1 <keyword>"
    return
  fi
  local pat="$1"
  for pdf in $(find . -iname '*.pdf'); do
    echo -ne "\033[K=> ${pdf}\r"
    nr=$(IFS=$'\n' pdftotext "${pdf}" - 2>/dev/null | grep -Ei "${pat}" - | wc -l)
    if [ ${nr} -gt 0 ]; then
      echo -e "\033[K\033[0;34m${pdf}\0033[0m     ${nr}"
    fi
  done
}
# }}}

# pdfsplit: split pages from pdf {{{
pdfsplit()
{
  if [ $# -lt 3 ]; then
    echo "usage: pdfsplit <file name> <first page> <last page>"
    return
  fi
  # this function takes 3 arguments:
  #     $1 is the input file
  #     $2 is the first page to extract
  #     $3 is the last page to extract
  #     output file will be named "inputfile_pXX-pYY.pdf"
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=${2} -dLastPage=${3} \
     -sOutputFile="${1%.pdf}_p${2}-p${3}.pdf" "${1}"
}
# }}}

# svg2pdf: convert svg to pdf and crop it {{{
svg2pdf()
{
  for svg in "$@"; do
    echo ${svg}
    local fn=${svg%.svg}
    inkscape -f ${svg} -A /tmp/${fn}.pdf
    pdfcrop /tmp/${fn}.pdf
    rm /tmp/${fn}.pdf
    mv /tmp/${fn}-crop.pdf ${fn}.pdf
  done
}

# }}}

# px: ps without noises {{{
px()
{
  ps -eo euser,pid,ppid,tname,c,rss,start,etime,cmd --forest | grep '^.*[^]]$'
}
# }}}

# d: dict {{{
# search dictionary and remember history
d ()
{
  if [[ -n $1 ]]; then
    echo "$1" >> ~/.dict_history
    dict "$1" | less
  else
    echo "usage : d <word>"
  fi
}
# }}}

# sshtnl/sshtnr/sshpr: building ssh tunnel at background {{{
sshtnl ()
{
  if [[ $# -ne 3 ]]; then
    echo "  Access to <[p-host:]p-port> on local machine will be forwarded to <t-host>:<t-port> in the remote network of <remote-host>"
    echo "  Usage: sshtnl <[username@]remote-host> <[p-host:]p-port> <t-host:t-port>"
    return 0
  fi
  local shost="$1"
  local phost="$2"
  local thost="$3"
  ssh -2fqnNT -L "${phost}":"${thost}" "${shost}"
}
sshtnr ()
{
  if [ $# -ne 3 ]; then
    echo "  Access to <[r-host:]r-port> on remote machine will be forwarded to <t-host:t-port> in local network"
    echo "  Usage: sshtnr <[username@]remote-host> <[r-host:]r-port> <t-host:t-port>"
    return
  fi
  local shost="$1"
  local rhost="$2"
  local thost="$3"
  ssh -2fqnNT -R "${rhost}":"${thost}" "${shost}"
}
sshpr ()
{
  if [ $# -ne 2 ]; then
    echo "Building SOCKS Proxy on <l-host:l-port> through <[username@]remote-host>"
    echo "  Usage: sshpr <[username@]remote-host> <[l-host:]l-port>"
    return
  fi
  local rhost="$1"
  local lhost="$2"
  ssh -2fqnNT -D "${lhost}" "${rhost}"
}
# }}}

# rbackup: backup using rsync {{{
rbackup ()
{
  local target="$HOME"/backup"$(pwd)"/
  mkdir -p $target && rsync -av . $target
}
# }}}

# rpush: push file/dir to the same location in remote machine {{{
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

# xmp3: convert audio files to mp3 {{{
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

# pacsrc: retrieving package from abs with the help from pacman {{{
pacsrc()
{
  local name=$1
  local AR=${HOME}/src/abs
  [[ ! -e ${AR} ]] && mkdir -p ${AR}
  if [[ ! -d ${AR} ]]; then
    echo ${AR} is not a directory
    return 1
  fi
  local repo=$(pacman -Si ${name} | grep '^Repository' | awk '{ print $3 }')
  if [[ -z ${repo} ]]; then
    return 1
  fi
  local fullname="${repo}/${name}"
  echo found ${fullname}
  ABSROOT=${AR} abs ${fullname}
}
# }}}

# vv: open file with xdg-open {{{
# open any file
vv ()
{
  if [ $# -lt 1 ]; then
    return
  fi
  xdg-open "$1" &>/dev/null
}
# }}}

# convchs/convcht: convert to utf-8 encoding {{{
convchs()
{
  local tf=$(mktemp)
  for f in "$@"; do
    iconv -f GB18030 -t UTF-8 "$f" -o ${tf}
    mv "${f}" "${f}.orig"
    mv ${tf} "${f}"
  done
}
convcht()
{
  local tf=$(mktemp)
  for f in "$@"; do
    iconv -f BIG-5 -t UTF-8 "$f" -o ${tf}
    mv "${f}" "${f}.orig"
    mv ${tf} "${f}"
  done
}
# }}}

# forall/forpar/fordif {{{
forall()
{
  if [[ $# -lt 2 ]]; then
    echo "Usage: forall <cfg-name> <cmd> ..."
    return 1
  fi
  local hosts=
  if [[ -r "${HOME}/.forall/${1}" ]]; then
    hosts=$(cat "${HOME}/.forall/${1}")
  elif [[ -r "/etc/forall/${1}" ]]; then
    hosts=$(cat "/etc/forall/${1}")
  fi
  [[ -z $hosts ]] && return 1
  for h in $hosts; do
    echo "== $h =="
    ssh "$h" "${@:2}"
  done
}
forpar()
{
  if [[ $# -lt 2 ]]; then
    echo "Usage: forpar <cfg-name> <cmd> ..."
    return 1
  fi
  local hosts=
  if [[ -r "${HOME}/.forall/${1}" ]]; then
    hosts=$(cat "${HOME}/.forall/${1}")
  elif [[ -r "/etc/forall/${1}" ]]; then
    hosts=$(cat "/etc/forall/${1}")
  fi
  [[ -z $hosts ]] && return 1
  for h in $hosts; do
    (ssh "$h" "${@:2}") &>/tmp/forpar.$h.log &
  done
}
fordif()
{
  if [[ $# -lt 2 ]]; then
    echo "Usage: fordif <cfg-name> <cmd> ..."
    return 1
  fi
  local hosts=
  if [[ -r "${HOME}/.forall/${1}" ]]; then
    hosts=$(cat "${HOME}/.forall/${1}")
  elif [[ -r "/etc/forall/${1}" ]]; then
    hosts=$(cat "/etc/forall/${1}")
  fi
  [[ -z $hosts ]] && return 1
  for h in $hosts; do
    (ssh "$h" "${@:2}") &>"/tmp/forpar.$h.log" &
  done
  wait
  [[ -e "/tmp/fordif.${1}.all" ]] && rm -f "/tmp/fordif.${1}.all"
  for h in $hosts; do
    cat "/tmp/forpar.$h.log" >>"/tmp/fordif.${1}.all"
  done
  sort /tmp/fordif.${1}.all | uniq -c | sort >"/tmp/fordif.${1}.dif"
  echo "/tmp/fordif.${1}.dif"
}
# }}}

# flamegraph + perf {{{
fperf ()
{
  if [[ -z "$@" ]]; then
    echo "Usage: fperf <commands> ..."
    return
  fi
  local rid=$(timestamp)
  local ghroot="https://raw.githubusercontent.com/brendangregg/FlameGraph/master"
  local bindir="${HOME}/program/usr/bin"
  local st1="${bindir}/stackcollapse-perf.pl"
  local st2="${bindir}/flamegraph.pl"
  if [[ ! -f "${bindir}/stackcollapse-perf.pl" ]]; then
    mkdir -p ~/program/usr/bin
    wget "${ghroot}/stackcollapse-perf.pl" -O "${st1}"
  fi
  if [[ ! -f "${bindir}/flamegraph.pl" ]]; then
    mkdir -p ~/program/usr/bin
    wget "${ghroot}/flamegraph.pl" -O "${st2}"
  fi
  perf record -g -- "$@"
  perf script > /tmp/fperf-${rid}.perf
  perl -w "${st1}" /tmp/fperf-${rid}.perf > /tmp/fperf-${rid}.folded
  perl -w "${st2}" /tmp/fperf-${rid}.folded > fperf-${rid}.svg
  rm -f /tmp/fperf-${rid}.perf /tmp/fperf-${rid}.folded
}

# }}}

# PS1 helpers {{{
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
# }}}

# $PS1 {{{
[[ -d "/tmp/ps1cache" ]] || mkdir -m777 -p "/tmp/ps1cache"
command -v tput &>/dev/null
if [[ 0 -eq $? ]]; then
  PS1='$(tput bold)$(tput smul)$(tput setb 0)$(tput setf 2)\u$(tput setf 7)@$(tput setf 5)\h$(tput setf 7)@$(tput setf 6)\t$(tput setf 7):$(tput setf 3)\w$(tput sgr0) $(tput setb 7)($(ps1_pwd_info))\n($(ps1_file_hints))$(tput sgr0)\n\$ '
else
  PS1='\u@\h@\t:\w\n\$ '
fi
# }}}

shopt -q -s cdspell checkwinsize no_empty_cmd_completion cmdhist dirspell

if [[ -z $BASHRC_LOADED ]]; then

[[ -f ~/.bashrc.local1 ]] && . ~/.bashrc.local1

# bash env misc {{{
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTIGNORE='&'
export EDITOR='vim'
#LD_LIBRARY_PATH=/opt/lib

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
  PATH=${CABALBIN}:${PATH}
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
    for bindir in bin sbin; do
      if [[ -d "${progdir}" && $? -eq 0 && -d "${progdir}/${bindir}" ]]; then
        PATH=${progdir}/${bindir}:${PATH}
      fi
    done
  done
fi
export PATH
# }}}

export BASHRC_LOADED=y
fi

[[ -f ~/.bashrc.localn ]] && . ~/.bashrc.localn
