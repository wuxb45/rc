#!/bin/bash
put ()
{
  echo "${1} -> ${2}"

  if [[ -f "${2}" ]]; then
    if [[ -x $(which colordiff 2>/dev/null) ]]; then
      colordiff "${2}" "${1}"
    elif [[ -x $(which diff 2>/dev/null) ]]; then
      diff "${2}" "${1}"
    fi
  fi

  if [[ -x $(which rsync 2>/dev/null) ]]; then
    rsync -c "${1}" "${2}"
  else
    cp "${1}" "${2}"
  fi
}

# normal .xx files
#echo "install all config files into your HOME."
DEST=${1:-${HOME}}
MCDIR=${2:-${PWD}}
echo "[DEST=${DEST}]"
echo "[MCDIR=${MCDIR}]"

if [[ ! -f ${MCDIR}/install.sh ]]; then
  echo "usage: install.sh <dest-dir> <myconfig-dir>"
  exit 0
fi

for cf in $(cat ${MCDIR}/config.list);
do
  put "${MCDIR}/$cf" "${DEST}/.$cf"
done

### special files
# terminator
mkdir -p ${DEST}/.config/terminator
put ${MCDIR}/terminator-config ${DEST}/.config/terminator/config

# matplotlib set default backend to svg
mkdir -p ${DEST}/.config/matplotlib
put ${MCDIR}/matplotlibrc ${DEST}/.config/matplotlib/matplotlibrc

wget -nv -T 2 -O ${DEST}/.gdb-dashboard "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit"

# vim
for subdir in plugin colors undodir ftdetect syntax indent ftplugin; do
  mkdir -p ${DEST}/.vim/${subdir}
done
rsync -av vim/ ${DEST}/.vim
