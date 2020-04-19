#!/bin/bash
if [[ -x $(which colordiff 2>/dev/null) ]]; then
  diff=colordiff
elif [[ -x $(which diff 2>/dev/null) ]]; then
  diff=diff
else
  echo "No diff or colordiff"
  exit 0
fi

if [[ -x $(which rsync 2>/dev/null) ]]; then
  copy="rsync -pc"
else
  copy="cp"
fi

put ()
{
  if [[ -f "${2}" ]]; then # if exists
    ${diff} "${2}" "${1}"
  fi
  ${copy} "${1}" "${2}"
}

webput ()
{
  local url="${1}"
  local dst="${2}"
  tmpfile=/tmp/.$$.webput
  if [[ -x $(which wget 2>/dev/null) ]]; then
    wget -qnv -T 2 -O ${tmpfile} "${url}"
  elif [[ -x $(which curl 2>/dev/null) ]]; then
    curl -s -m 2 -o ${tmpfile} "${url}"
  fi
  if [[ -f ${tmpfile} ]]; then
    put ${tmpfile} "${DEST}/${dst}"
  else
    echo "skip ${dst}"
  fi
}

# normal .xx files
#echo "install all config files into your HOME."
DEST=${1:-${HOME}}
echo "[DEST=${DEST}]"

# dot files
for cf in $(cat ./config.list); do
  put "$cf" "${DEST}/.$cf"
done

mkdir -p ${DEST}/program/usr/bin
${copy} -r bin/ ${DEST}/program/usr/bin

# [Deprecated] terminator
#mkdir -p ${DEST}/.config/terminator
#put terminator-config ${DEST}/.config/terminator/config

# Tilix uses dconf to load/dump settings
if [[ -x $(which dconf 2>/dev/null) ]]; then
  dconf load /com/gexperts/Tilix/ < tilix.dconf
else
  echo "dconf not found. Skip Tilix."
fi

# hide desktop (Gnome)
mkdir -p ${DEST}/.local/share/applications
put hide.desktop ${DEST}/.local/share/applications/hide.desktop

# matplotlib set default backend to svg
mkdir -p ${DEST}/.config/matplotlib
put matplotlibrc ${DEST}/.config/matplotlib/matplotlibrc

# gdb dashboard
url="https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit"
dst=".gdb-dashboard"
webput ${url} ${dst}

## diff-highlight
#url="https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight"
#dst="program/usr/bin/diff-highlight"
#webput ${url} ${dst}
#chmod +x ${DEST}/${dst}

# vim
for subdir in plugin colors undodir ftdetect syntax indent ftplugin; do
  mkdir -p ${DEST}/.vim/${subdir}
done
${copy} -r vim/ ${DEST}/.vim

#neovim
mkdir -p ${DEST}/.config/nvim
put nvimrc ${DEST}/.config/nvim/init.vim
