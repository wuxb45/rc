#
# ~/.bashrc
#
# vim: fdm=marker

# $PATH {{{
if [[ -z ${PATH_LOADED} ]]; then
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

PROGRAMDIR=${HOME}/program
if [ -f "${PROGRAMDIR}/blacklist" ]; then
  blacklist=$(cat ${PROGRAMDIR}/blacklist)
else
  blacklist=""
fi # blacklist

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
fi # program
export PATH
export PATH_LOADED=y
fi # PATH_LOADED
# }}}

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
alias vcheck='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias gcheck='LD_PRELOAD=/usr/lib/libtcmalloc.so HEAPCHECK=normal'
alias timestamp='date +%Y-%m-%d-%H-%M-%S-%N'
alias lsb='lsblk -o KNAME,FSTYPE,MOUNTPOINT,MODEL,SIZE,MIN-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,DISC-ZERO -x KNAME'
# gtags then htags
alias htags='htags -agInosT --show-position --fixed-guide'
alias pgdb='sudo -Hi gdb -p'
alias ptop='perf top -p'
# term color
alias tfg='tput setaf'
alias tbg='tput setab'
# clear
alias txx='tput sgr0'
# }}}

# cgshell {{{
# todo add more limits
cgshell ()
{
  hash cgm &>/dev/null
  if [[ 0 -ne $? ]]; then
    echo "cgm not available"
    return 1
  fi
  if [[ $# -lt 1 ]]; then
    echo "Usage: $FUNCNAME <size-in-MB>"
    return 1
  fi
  sudo cgm create memory small
  sudo cgm chown memory small ${USER} ${USER}
  sudo cgm setvalue memory small memory.limit_in_bytes $((${1} * 1024 * 1024))
  sudo cgm movepid memory small $$
}
# }}} cgshell

# ktags {{{
# .ki_path .ki_ids .ki_wl_{arch,drivers}
ktags ()
{
  local tignore="/tmp/.${USER}.kip"
  cp ${HOME}/.ki_path ${tignore}
  for sub in arch drivers; do
    local wf="${HOME}/.ki_wl_${sub}"
    local whites=
    if [[ -f ${wf} ]]; then
      whites=$(cat ${wf})
    fi
    local all=$(ls -d ${sub}/*/)
    local found=
    for a in ${all[@]}; do
      d=${a%/}
      found=
      for w in ${whites[@]}; do
        if [[ ${d} == ${w} ]]; then
          found="found"
          echo "white-listing ${d}"
          break
        fi
      done
      if [[ -z ${found} ]]; then
        echo ${d} >> ${tignore}
      fi
    done
  done
  ctags -I "@${HOME}/.ki_ids" --exclude="@${tignore}" -R .
  rm -f ${tignore}
}
# }}} ktags

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

# pdf tools {{{
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

pdfcut()
{
  if [[ $# -lt 3 ]]; then
    echo "  Usage: $FUNCNAME <pdf-in> <pdf-out> <first-page> [<last-page>]"
    return 0
  fi
  local head="gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER"
  local p0="-dFirstPage=${3}"
  local pn=
  if [[ -n ${4} ]]; then
    pn="-dLastPage=${4}"
  fi
  $head $p0 $pn -sOutputFile="${2}" "${1}"
}

pdfcut1()
{
  if [[ $# -lt 2 ]]; then
    echo "  Usage: $FUNCNAME <pdf-in> <first-page> [<last-page>]"
    return 0
  fi
  pdfcut "${1}" "${1%.pdf}_p${2}-p${3}.pdf" ${2} ${3}
}

pdfbreak()
{
  if [[ $# -ne 2 ]]; then
    echo "  Usage: $FUNCNAME <file-name> <nr-pages>"
    return 0
  fi
  for pp in $(seq 1 ${2}); do
    pdfcut "${1}" "${1%.pdf}_${pp}.pdf" "${pp}" "${pp}"
  done
}

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
  OPT='-e'
  if [[ -n ${1} ]]; then
    OPT="-u ${1}"
  fi
  ps ${OPT} -o 'tty:5,start:8,time:8,rss:8,euser:6,pid:6,ppid:6,cmd' --forest | grep -v ']$' | \
  (
    local leftsize=0;
    while read -r line; do
      if [[ $leftsize -eq 0 ]]; then
        leftsize=$(( ${#line} - 3))
        echo "${line}"
      else
        echo -n "${line:0:$leftsize}"
        tfg 18
        echo "${line:$leftsize}"
        txx
      fi
    done
  )
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

# ireboot: force immediate reboot (root) {{{
ireboot()
{
  if [[ ${USER} -ne "root" ]]; then
    echo "Only root has permission to ireboot"
  else
    sudo bash -c 'echo 1 > /proc/sys/kernel/sysrq; echo b > /proc/sysrq-trigger'
  fi
}
# }}}

# PS1 {{{
# show some files in current dir
ps1_file_hints ()
{
  local hintinfo="/tmp/.PS1.${USER}.$$.ps1hint"
  local hinttext="/tmp/.PS1.${USER}.$$.ps1text"
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
  set -f
  for x in $(ls -tF | head -n 40); do
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

hash tput &>/dev/null
if [[ 0 -eq $? ]]; then
  # user host
  PS_1='$(tput bold)$(tput smul)$(tbg 0)$(tfg 2)\u$(tfg 7)@$(tfg 5)\h'
  # time pwd
  PS_2='$(tfg 7)@$(tfg 6)\t$(tfg 7):$(tfg 3)\w$(txx) '
  # working dir info
  PS_w='$(tbg 7)($(ps1_pwd_info) #$(tfg 9)$(ls -U | wc -w)$(tfg 0))'
  # hints at new line
  PS_h='\n($(ps1_file_hints))'
  # the prompt $
  PS_p='$(txx)\n\$ '
  PS1="${PS_1}${PS_2}${PS_w}${PS_h}${PS_p}"
else
  PS1='\u@\h@\t:\w\n\$ '
fi
# }}} PS1

shopt -q -s cdspell checkwinsize no_empty_cmd_completion cmdhist dirspell

# exports {{{

if [[ -z $BASHRC_LOADED ]]; then

[[ -f ~/.bashrc.local1 ]] && . ~/.bashrc.local1

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTIGNORE='&'
export EDITOR='vim'

export BASHRC_LOADED=y
fi # BASHRC_LOADED

[[ -f ~/.bashrc.localn ]] && . ~/.bashrc.localn

# }}}
