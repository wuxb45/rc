#!/bin/bash
put ()
{
  echo "${1} -> ${2}"
  if [ -x $(which colordiff) ]; then
    colordiff "${1}" "${2}"
  elif [ -x $(which diff) ]; then
    diff "${1}" "${2}"
  fi
  rsync -u "${1}" "${2}"
}

# normal .xx files
#echo "install all config files into your HOME."

for cf in $(cat config.list);
do
  put "$cf" "$HOME/.$cf"
done

### special files
# terminator
mkdir -p ~/.config/terminator
put terminator-config ~/.config/terminator/config

# Adobe Reader 9.0
#mkdir -p ~/.adobe/Acrobat/9.0/Preferences
#put reader_prefs ~/.adobe/Acrobat/9.0/Preferences/

# Cabal
#mkdir -p ~/.cabal
#put cabal-config ~/.cabal/config

# Yong input method
#mkdir -p ~/.yong
#put yong.ini ~/.yong/yong.ini

# matplotlib set default backend to svg
mkdir -p ~/.config/matplotlib
put matplotlibrc ~/.config/matplotlib/matplotlibrc

# vim
mkdir -p ~/.vim/undodir
mkdir -p ~/.vim/ftdetect
put vim/ftdetect/hsc.vim   ~/.vim/ftdetect/hsc.vim
put vim/ftdetect/scala.vim ~/.vim/ftdetect/scala.vim
put vim/ftdetect/stap.vim  ~/.vim/ftdetect/stap.vim
mkdir -p ~/.vim/syntax
put vim/syntax/scala.vim   ~/.vim/syntax/scala.vim
put vim/syntax/stap.vim    ~/.vim/syntax/stap.vim
mkdir -p ~/.vim/indent
put vim/indent/scala.vim   ~/.vim/indent/scala.vim
put vim/indent/stap.vim    ~/.vim/indent/stap.vim
mkdir -p ~/.vim/ftplugin
put vim/ftplugin/stap.vim  ~/.vim/ftplugin/stap.vim
