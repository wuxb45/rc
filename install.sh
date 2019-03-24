#!/bin/bash
put ()
{
  if [[ -f "${2}" ]]; then
    if [[ -x $(which colordiff 2>/dev/null) ]]; then
      colordiff "${2}" "${1}"
    elif [[ -x $(which diff 2>/dev/null) ]]; then
      diff "${2}" "${1}"
    fi
  fi

  if [[ -x $(which rsync 2>/dev/null) ]]; then
    rsync -pc "${1}" "${2}"
  else
    cp "${1}" "${2}"
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
rsync -rpc bin/ ${DEST}/program/usr/bin

# terminator
mkdir -p ${DEST}/.config/terminator
put terminator-config ${DEST}/.config/terminator/config

# Tilix uses dconf to load/dump settings
if [[ -x $(which dconf 2>/dev/null) ]]; then
  dconf load /com/gexperts/Tilix/ < tilix.dconf
fi

# matplotlib set default backend to svg
mkdir -p ${DEST}/.config/matplotlib
put matplotlibrc ${DEST}/.config/matplotlib/matplotlibrc

tmpdb=/tmp/.$$.gdbdb
wget -qnv -T 2 -O $tmpdb "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit"
put $tmpdb ${DEST}/.gdb-dashboard

# vim
for subdir in plugin colors undodir ftdetect syntax indent ftplugin; do
  mkdir -p ${DEST}/.vim/${subdir}
done
rsync -rpc vim/ ${DEST}/.vim
