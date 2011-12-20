#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias tree='tree -C'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# git alias
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gd='git diff'
alias gpl='git pull'
alias gps='git push'
alias gst='git status'

PS1='\[\033[01;32m\u\]\[\033[01;35m@\]\[\033[01;36m\h\]\[\033[01;35m@\]\[\e[33;1m\t\]\[\033[01;00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '

PROGRAM_DIR=$HOME/program
export PATH=$HOME/.cabal/bin:$PATH
for prog in `ls $PROGRAM_DIR`;
do
  export "PATH=$PROGRAM_DIR/$prog/bin:$PATH"
done

export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTIGNORE='&:bg:fg:ll:h'

export EDITOR='vim'
export LD_LIBRARY_PATH=/usr/local/lib

alias gr='grep -nr'
