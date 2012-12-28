#!/bin/bash
put ()
{
  rsync -u $1 $2
}

# normal .xx files
echo "install all config files into your HOME."
for cf in $(cat config.list);
do
  echo "$cf -> $HOME/.$cf"
  put "$cf" "$HOME/.$cf"
done

### special files
# terminator
echo "terminator-config -> ~/.config/terminator/config"
mkdir -p ~/.config/terminator
put terminator-config ~/.config/terminator/config

# Adobe Reader 9.0
echo "reader_prefs -> ~/.adobe/Acrobat/9.0/Preferences/"
mkdir -p ~/.adobe/Acrobat/9.0/Preferences
put reader_prefs ~/.adobe/Acrobat/9.0/Preferences/

# Cabal
echo "cabal-config -> ~/.cabal/config"
mkdir -p ~/.cabal
put cabal-config ~/.cabal/config

# Yong input method
echo "yong.ini -> ~/.yong/yong.ini"
mkdir -p ~/.yong
put yong.ini ~/.yong/yong.ini

# vim
mkdir -p ~/.vim/undodir
mkdir -p ~/.vim/ftdetect
put vim/ftdetect/hsc.vim ~/.vim/ftdetect/hsc.vim
put vim/ftdetect/scala.vim ~/.vim/ftdetect/scala.vim
mkdir -p ~/.vim/syntax
put vim/syntax/scala.vim ~/.vim/syntax/scala.vim
mkdir -p ~/.vim/indent
put vim/indent/scala.vim ~/.vim/indent/scala.vim

