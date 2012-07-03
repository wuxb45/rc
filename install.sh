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

# vim filetype.vim
echo "filetype.vim -> ~/.vim/filetype.vim"
mkdir -p ~/.vim/undodir
put filetype.vim ~/.vim/filetype.vim
