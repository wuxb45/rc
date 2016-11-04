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
alias grc='grep -nr --include=*.{c,cc,cpp,cxx,C,h,hh,hpp,py,hs,java,sh,pl,tex}'
alias dfh='df -h'
alias du0='du -h --max-depth=0'
alias du1='du -h --max-depth=1'
alias freeh='free -h'
# update id3 for mp3 files
#alias mp3chinese='find . -iname "*.mp3" -execdir mid3iconv -e gbk --remove-v1 {} \;'
alias vcheck='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias timestamp='date +%Y-%m-%d-%H-%M-%S-%N'
alias lsb='lsblk -o KNAME,FSTYPE,MOUNTPOINT,MODEL,SIZE,MIN-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,DISC-ZERO'
alias ktags="ctags -I @${HOME}/.ktags_ignore_id --exclude=@${HOME}/.ktags_ignore_path -R ."
# }}}

# fd/fd1/fdh: find in filename {{{
fd1 ()
{
  if [[ -z ${1} ]]; then
    echo "  Usage: $FUNCNAME <keyword>"
  else
    find . -maxdepth 1 -iname "*${1}*"
  fi
}

fd ()
{
  if [[ -z ${1} ]]; then
    echo "Find files whose name contains <keyword>"
    echo "  Usage: $FUNCNAME <keyword>"
  else
    find . -iname "*${1}*"
  fi
}

fdh ()
{
  if [[ -z ${1} ]]; then
    echo "Find header files by <keyword>"
    echo "  Usage: $FUNCNAME <keyword>"
  else
    local gccprefix="/usr/lib/gcc/$(gcc -dumpmachine)/$(gcc -dumpversion)"
    find /usr/include /usr/local/include ${gccprefix}/include ${gccprefix}/include-fixed -iname "*${1}*"
  fi
}
# }}}

# map2pdf: convert manpages to pdf {{{
man2pdf()
{
  if [[ $# -lt 1 ]]; then
    echo "  Usage : $FUNCNAME [<section>] <name>"
    return 0
  fi

  local psfile=/tmp/map2pdf_tmp.ps
  local pdffile="${1}${2}.pdf"
  man -t ${1} ${2} > ${psfile}
  if [[ 0 -eq $? ]]; then
    ps2pdf ${psfile} ${pdffile}
    echo "-> ${pdffile}"
  fi
  rm -f ${psfile}
}
# }}}

# readmd: read markdown in lynx (by converting to on-the-fly html) {{{
readmd()
{
  markdown ${1} | lynx -stdin
}
# }}}

# pdfgrep/pdfgrep1: grep pdf text {{{
pdfgrep()
{
  if [[ $# -ne 1 ]]; then
    echo "Grep all occurances of <keyword> in pdf files"
    echo "  Usage : $FUNCNAME <keyword>"
    return 0
  fi
  local pat="$1"
  for pdf in $(find . -iname '*.pdf'); do
    echo -ne "\033[K=> ${pdf}\r"
    IFS=$'\n' pdftotext "${pdf}" - 2>/dev/null | grep -nEHi --color=auto --label="${pdf}" "${pat}" -
  done
}

pdfgrep1()
{
  if [[ $# -ne 1 ]]; then
    echo "Find pdf files that contain <keyword>"
    echo "  Usage : $FUNCNAME <keyword>"
    return 0
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
  if [[ $# -ne 3 ]]; then
    echo "  Usage: $FUNCNAME <file name> <first page> <last page>"
    return 0
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
  if [[ $# -eq 0 ]]; then
    echo "  Usage: $FUNCNAME <svg-file> ..."
  fi
  for svg in "$@"; do
    echo ${svg}
    local fn=${svg%.svg}
    inkscape -f ${svg} -A /tmp/${fn}.pdf
    pdfcrop /tmp/${fn}.pdf ${fn}.pdf
    rm /tmp/${fn}.pdf
  done
}

# }}}

# px: ps without noises {{{
px()
{
  ps -eo euser,pid,ppid,tname,c,rss,start,etime,cmd --forest | grep '^.*[^]]$'
}
# }}}

# sshtnl/sshtnr/sshpr: building ssh tunnel at background {{{
sshtnl ()
{
  if [[ $# -ne 3 ]]; then
    echo "Access to <[p-host:]p-port> on local machine will be forwarded to <t-host>:<t-port> in the remote network of <remote-host>"
    echo "  Usage: $FUNCNAME <[username@]remote-host> <[p-host:]p-port> <t-host:t-port>"
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
    echo "Access to <[r-host:]r-port> on remote machine will be forwarded to <t-host:t-port> in local network"
    echo "  Usage: $FUNCNAME <[username@]remote-host> <[r-host:]r-port> <t-host:t-port>"
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
    echo "  Usage: $FUNCNAME <[username@]remote-host> <[l-host:]l-port>"
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
  if [[ $# -ne 2 ]]; then
    echo "Push file/dir to the same location in a remote machine."
    echo "  Usage: $FUNCNAME <dir-or-file> <target-host>"
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
  if [[ $# -lt 1 ]]; then
    echo "  Usage: $FUNCNAME <package>"
    return
  fi
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
  echo "pacsrc: package file ready at ${AR}/${fullname}"
}
# }}}

# {{{ pactree: pacman package dependences
__pacgrep()
{
  local key=${1}
  local pkg=${2}
  [[ $# -lt 2 || ${pkg} == 'None' ]] && return
  for val in $(pacman -Qi ${pkg} 2>/dev/null | grep "${key}" | sed -e 's/^.*: \(.*\)$/\1/'); do
    pkg1=$(echo "${val}" | sed -e 's/^\([-a-zA-Z0-9_]*\).*$/\1/')
    [[ ${pkg1} != "None" ]] && echo "${pkg1}"
  done
}

__pacdep()
{
  [[ $# -lt 2 || ${1} == 'None' ]] && return
  local pkg=${1}
  local pre=${2}
  for dep in $(__pacgrep 'Depends On' ${pkg}); do
    echo "-${pre}>${dep}"
    __pacdep ${dep} "${pre}-"
  done
  for opt in $(__pacgrep 'Optional Deps' ${pkg}); do
    echo "-${pre}*${opt}"
    __pacdep ${dep} "${pre}-"
  done
}

__pacreq()
{
  [[ $# -lt 2 || ${1} == 'None' ]] && return
  local pkg=${1}
  local pre=${2}
  for dep in $(__pacgrep 'Required By' ${pkg}); do
    echo "-${pre}>${dep}"
    __pacreq ${dep} "${pre}--"
  done
  for opt in $(__pacgrep 'Optional For' ${pkg}); do
    echo "-${pre}*${opt}"
    __pacreq ${dep} "${pre}--"
  done
}

pactree()
{
  local pkg=${1}
  if [[ $# -ne 1 ]]; then
    echo "Print dependence trees of <package>"
    echo "  Usage $FUNCNAME <package>"
    return
  fi
  echo "## Dep tree:"
  __pacdep ${pkg} ''
  echo "## Req tree:"
  __pacreq ${pkg} ''
}
# }}}

# vv: open file with xdg-open {{{
# open any file
vv ()
{
  if [[ $# -eq 1 ]]; then
    xdg-open "$1" &>/dev/null
  fi
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

# {{{ forall/forpar/fordif: parallel remote execution
forall()
{
  if [[ $# -lt 2 ]]; then
    echo "  Usage: $FUNCNAME <cfg-name> <cmd> ..."
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
    echo "  Usage: $FUNCNAME <cfg-name> <cmd> ..."
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
    echo "  Usage: $FUNCNAME <cfg-name> <cmd> ..."
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
  vim "/tmp/fordif.${1}.dif"
}
# }}}

# {{{ fperf: perf + flamegraph
fperf ()
{
  if [[ $# -eq 0 ]]; then
    echo "  Usage: $FUNCNAME <commands> ..."
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
  perf record --call-graph lbr -- "$@"
  perf script > /tmp/fperf-${rid}.perf
  perl -w "${st1}" /tmp/fperf-${rid}.perf > /tmp/fperf-${rid}.folded
  perl -w "${st2}" /tmp/fperf-${rid}.folded > fperf-${rid}.svg
  rm -f /tmp/fperf-${rid}.perf /tmp/fperf-${rid}.folded
}

# }}}

# {{{ ccheck: cppcheck works
ccheck()
{
  local GCCINSTALL="/usr/lib/gcc/$(gcc -dumpmachine)/$(gcc -dumpversion)"
  cppcheck -I/usr/local/include -I/usr/include -I ${GCCINSTALL}/include -I ${GCCINSTALL}/include-fixed \
    -v -DDUMMY --std=c11 --language=c --enable=all "$@"
}
# }}}

# {{{ ireboot: force immediate reboot (root)
ireboot()
{
  if [[ ${USER} -ne "root" ]]; then
    echo "Only root has permission to ireboot"
  else
    echo 1 > /proc/sys/kernel/sysrq
    echo b > /proc/sysrq-trigger
  fi
}
# }}}

# {{{ PS1 helpers
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

# {{{ $PS1
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
fi # BASHRC_LOADED

[[ -f ~/.bashrc.localn ]] && . ~/.bashrc.localn
