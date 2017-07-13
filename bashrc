#
# ~/.bashrc
#
# vim: fdm=marker

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
# term color
alias tfg='tput setaf'
alias tbg='tput setab'
# clear
alias txx='tput sgr0'
# }}}

# PS1 {{{
# show some files in current dir
ps1_hints ()
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

ps1_pwd()
{
  echo $(ls -dlhF --time-style=long-iso) | tr -s ' ' | cut -d' ' -f1,3,4,6,7
}

hash tput &>/dev/null
if [[ 0 -eq $? ]]; then
  # user host
  PS_1="$(tput bold)$(tput smul)$(tbg 0)$(tfg 2)\u$(tfg 7)@$(tfg 5)\h"
  # time pwd
  PS_2="$(tfg 7)@$(tfg 6)\t$(tfg 7):$(tfg 3)\w$(txx) "
  # working dir info
  PS_w="$(tbg 7)("'$(ps1_pwd)'" #$(tfg 9)"'$(ls -U | wc -w)'"$(tfg 0))"
  # hints at new line
  PS_h='\n($(ps1_hints))'
  # the prompt $
  PS_p="$(txx)\n\$ "
  PS1="${PS_1}${PS_2}${PS_w}${PS_h}${PS_p}"
else
  PS1="\u@\h@\t:\w\n\$ "
fi
# }}} PS1

# exports {{{
if [[ -z $BASHRC_LOADED ]]; then

prog=${HOME}/program
if [[ -d "${prog}" ]]; then
  if [[ -f "${prog}/.wl" ]]; then
    wl=$(cat "${prog}/.wl")
  else
    wl=$(ls ${prog})
  fi # white-list

  for home in ${wl}; do
    proghome=${prog}/${home}
    for bindir in bin sbin; do
      if [[ -d "${proghome}" && $? -eq 0 && -d "${proghome}/${bindir}" ]]; then
        PATH=${proghome}/${bindir}:${PATH}
      fi
    done
  done
  export PATH
fi # program

[[ -f ~/.bashrc.local1 ]] && . ~/.bashrc.local1

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTIGNORE='&'
export EDITOR='vim'

export BASHRC_LOADED=y
fi # BASHRC_LOADED
# }}}

[[ -f ~/.bashrc.localn ]] && . ~/.bashrc.localn
