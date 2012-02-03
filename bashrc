#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
alias mp3chinese='find . -iname "*.mp3" -execdir mid3iconv -e gbk --remove-v1 {} \;'
# haskell file server
alias hfs.d='killall hfs; nohup hfs &>/dev/null &'

function ps1_file_hints ()
{
  i=1
  for x in $*; do
    if [ $i -ge 5 ]; then
      echo -n "$x ... $(echo $* | wc -w) total"
      return
    else
      echo -n "$x "
    fi
    i=$(($i+1))
  done
}

#PS1='\[\033[01;31m\u\]\[\033[01;36m@\]\[\033[01;35m\h\]\[\033[01;36m@\]\[\e[32;1m\t\]\[\033[01;00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
PS1='\[\033[01;31m\u\]\[\033[01;36m@\]\[\033[01;35m\h\]\[\033[01;36m@\]\[\e[32;1m\t\]\[\033[01;00m\]:\[\033[01;34m\]\w\[\033[00m\] ($(ps1_file_hints `ls`))\n\$ '

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
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTIGNORE='&:bg:fg:ll:h'

export EDITOR='vim'
export LD_LIBRARY_PATH=/opt/lib

shopt -s cdspell checkwinsize no_empty_cmd_completion

