#!/bin/bash
put ()
{
  echo "${1} -> ${2}"

  if [[ -x $(which colordiff 2>/dev/null) ]]; then
    colordiff "${1}" "${2}"
  elif [[ -x $(which diff 2>/dev/null) ]]; then
    diff "${1}" "${2}"
  fi

  if [[ -x $(which rsync 2>/dev/null) ]]; then
    rsync -c "${1}" "${2}"
  else
    cp "${1}" "${2}"
  fi
}

# normal .xx files
#echo "install all config files into your HOME."
DEST=${DEST:-${HOME}}
echo "[DEST=${DEST}]"

for cf in $(cat config.list);
do
  put "$cf" "$DEST/.$cf"
done

### special files
# terminator
mkdir -p ${DEST}/.config/terminator
put terminator-config ${DEST}/.config/terminator/config

# Adobe Reader 9.0
#mkdir -p ${DEST}/.adobe/Acrobat/9.0/Preferences
#put reader_prefs ${DEST}/.adobe/Acrobat/9.0/Preferences/

# Cabal
#mkdir -p ${DEST}/.cabal
#put cabal-config ${DEST}/.cabal/config

# Yong input method
#mkdir -p ${DEST}/.yong
#put yong.ini ${DEST}/.yong/yong.ini

# matplotlib set default backend to svg
mkdir -p ${DEST}/.config/matplotlib
put matplotlibrc ${DEST}/.config/matplotlib/matplotlibrc

# vim
mkdir -p ${DEST}/.vim/undodir
mkdir -p ${DEST}/.vim/ftdetect
put vim/ftdetect/hsc.vim   ${DEST}/.vim/ftdetect/hsc.vim
put vim/ftdetect/scala.vim ${DEST}/.vim/ftdetect/scala.vim
put vim/ftdetect/stap.vim  ${DEST}/.vim/ftdetect/stap.vim
mkdir -p ${DEST}/.vim/syntax
put vim/syntax/scala.vim   ${DEST}/.vim/syntax/scala.vim
put vim/syntax/stap.vim    ${DEST}/.vim/syntax/stap.vim
mkdir -p ${DEST}/.vim/indent
put vim/indent/scala.vim   ${DEST}/.vim/indent/scala.vim
put vim/indent/stap.vim    ${DEST}/.vim/indent/stap.vim
mkdir -p ${DEST}/.vim/ftplugin
put vim/ftplugin/stap.vim  ${DEST}/.vim/ftplugin/stap.vim
