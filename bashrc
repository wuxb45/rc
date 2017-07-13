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
# }}}

# PS1 {{{
hash tput &>/dev/null
if [[ 0 -eq $? ]]; then
  # user host
  PS_1="$(tput bold)$(tput smul)$(tput setab 0)$(tput setaf 2)\u$(tput setaf 7)@$(tput setaf 5)\h"
  # time pwd
  PS_2="$(tput setaf 7)@$(tput setaf 6)\t$(tput setaf 7):$(tput setaf 3)\w$(tput sgr0) "
  # working dir info
  PS_w="$(tput setab 252)$(tput setaf 16)"'$(ps1hlpr1)\n($(ps1hlpr2 $$))'"$(tput sgr0)"
  # the prompt $
  PS_p="\n\$ "
  PS1="${PS_1}${PS_2}${PS_w}${PS_p}"
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
