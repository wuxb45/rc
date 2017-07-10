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

shopt -q -s cdspell checkwinsize no_empty_cmd_completion cmdhist dirspell

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
