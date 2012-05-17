#!/bin/bash

# normal .xx files
echo "install all config files into your HOME."
for cf in $(cat config.list);
do
  echo "$cf -> $HOME/.$cf"
  cp "$cf" "$HOME/.$cf"
done

### special files
# terminator
echo "terminator-config -> ~/.config/terminator/config"
mkdir -p ~/.config/terminator
cp terminator-config ~/.config/terminator/config

# Adobe Reader 9.0
echo "reader_prefs -> ~/.adobe/Acrobat/9.0/Preferences/"
mkdir -p ~/.adobe/Acrobat/9.0/Preferences
cp reader_prefs ~/.adobe/Acrobat/9.0/Preferences/

# Cabal
echo "cabal-config -> ~/.cabal/config"
mkdir -p ~/.cabal
cp cabal-config ~/.cabal/config

# Yong input method
echo "yong.ini -> ~/.yong/yong.ini"
mkdir -p ~/.yong
cp yong.ini ~/.yong/yong.ini

# vim filetype.vim
echo "filetype.vim -> ~/.vim/filetype.vim"
mkdir -p ~/.vim
cp filetype.vim ~/.vim/filetype.vim
