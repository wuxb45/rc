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
alias grc='grep -nr --include=*.{cc,c,h,cpp,cxx,C,py,hs,java,sh,pl,tex}'
alias df='df -h'
alias du0='du -h --max-depth=0'
alias du1='du -h --max-depth=1'
alias free='free -h'
# update id3 for mp3 files
alias mp3chinese='find . -iname "*.mp3" -execdir mid3iconv -e gbk --remove-v1 {} \;'
alias sshpr='ssh -C2fqTnN -D 1984'
alias vcheck='valgrind --leak-check=full '
alias vvcheck='valgrind --leak-check=full --show-leak-kinds=all '
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
    echo "usage : $0 <keyword>"
    return
  fi
  local pat="$1"
  for pdf in $(find . -iname '*.pdf'); do
    echo -ne "--> \033[K${pdf}\r"
    IFS=$'\n' pdftotext "${pdf}" - 2>/dev/null | grep -nEH --color=auto --label="${pdf}" "${pat}" -
  done
}
# }}}

# pdfsplit: split pages from pdf {{{
pdfsplit()
{
  if [ $# -lt 3 ]; then
    echo "usage: pdfsplit <first page> <last page> <file name>"
    return
  fi
  # this function takes 3 arguments:
  #     $1 is the first page to extract
  #     $2 is the last page to extract
  #     $3 is the input file
  #     output file will be named "inputfile_pXX-pYY.pdf"
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=${1} -dLastPage=${2} \
     -sOutputFile="${3%.pdf}_p${1}-p${2}.pdf" "${3}"
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
    echo "usage : $0 <word>"
  fi
}
# }}}

# sshtn/sshtnr: building ssh tunnel at background {{{
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

# bash env misc {{{
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTIGNORE='&'
export EDITOR='vim'
export LD_LIBRARY_PATH=/opt/lib

shopt -s cdspell checkwinsize no_empty_cmd_completion
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

PS1='$(tput bold)$(tput smul)$(tput setb 0)$(tput setf 2)\u$(tput setf 7)@$(tput setf 5)\h$(tput setf 7)@$(tput setf 6)\t$(tput setf 7):$(tput setf 3)\w$(tput sgr0) $(tput setb 7)($(ps1_pwd_info))\n($(ps1_file_hints))$(tput sgr0)\n\$ '
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
    if [[ -d "${progdir}" && $? -eq 0 && -d "${progdir}/bin" ]]; then
      export "PATH=${progdir}/bin:${PATH}"
    fi
  done
fi
# }}}

[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local
