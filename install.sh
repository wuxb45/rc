#!/usr/bin/env bash
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
    rm -f ${tmpfile}
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

mkdir -p ${DEST}/.local/bin
${copy} -r bin/ ${DEST}/.local/bin

# [Deprecated] terminator
#mkdir -p ${DEST}/.config/terminator
#put terminator-config ${DEST}/.config/terminator/config

# Tilix uses dconf to load/dump settings
if [[ -x $(which dconf 2>/dev/null) ]]; then
  dconf load /com/gexperts/Tilix/ < tilix.dconf
  dconf load /org/gnome/desktop/wm/keybindings/ < gnome-keybindings.dconf
  dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ < custom-keybindings.dconf
else
  echo "dconf not found. Skip Tilix."
fi

# hide desktop (Gnome)
mkdir -p ${DEST}/.local/share/applications
put hide.desktop ${DEST}/.local/share/applications/hide.desktop

# matplotlib set default backend to svg
mkdir -p ${DEST}/.config/matplotlib
put matplotlibrc ${DEST}/.config/matplotlib/matplotlibrc

# gtk copy-paste
mkdir -p ${DEST}/.config/gtk-3.0
put gtk.css ${DEST}/.config/gtk-3.0/gtk.css

# yay
mkdir -p ${DEST}/.config/yay
put yay-config.json ${DEST}/.config/yay/config.json

## gdb dashboard
#url="https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit"
#dst=".gdb-dashboard"
#webput ${url} ${dst}

## diff-highlight
#url="https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight"
#dst="program/usr/bin/diff-highlight"
#webput ${url} ${dst}
#chmod +x ${DEST}/${dst}

# vim
for subdir in plugin colors undodir ftdetect syntax indent ftplugin pack/p/opt pack/p/start; do
  mkdir -p ${DEST}/.vim/${subdir}
done
${copy} -r vim/ ${DEST}/.vim

# tagbar
[[ -d ${DEST}/.vim/pack/p/start/tagbar ]] || git clone https://github.com/preservim/tagbar.git ${DEST}/.vim/pack/p/start/tagbar
git -C ${DEST}/.vim/pack/p/start/tagbar pull

# nerdtree
[[ -d ${DEST}/.vim/pack/p/start/nerdtree ]] || git clone https://github.com/preservim/nerdtree.git ${DEST}/.vim/pack/p/start/nerdtree
git -C ${DEST}/.vim/pack/p/start/nerdtree pull

# supertab
[[ -d ${DEST}/.vim/pack/p/start/supertab ]] || git clone https://github.com/ervandew/supertab.git ${DEST}/.vim/pack/p/start/supertab
git -C ${DEST}/.vim/pack/p/start/supertab pull

# Copilot
[[ -d ${DEST}/.vim/pack/p/start/copilot ]] || git clone https://github.com/github/copilot.vim.git ${DEST}/.vim/pack/p/start/copilot
git -C ${DEST}/.vim/pack/p/start/copilot pull

# rainbow csv
[[ -d ${DEST}/.vim/pack/p/start/rainbow_csv ]] || git clone https://github.com/mechatroner/rainbow_csv.git ${DEST}/.vim/pack/p/start/rainbow_csv
git -C ${DEST}/.vim/pack/p/start/rainbow_csv pull

#neovim
mkdir -p ${DEST}/.config/nvim
put nvimrc ${DEST}/.config/nvim/init.vim

#alacritty
put alacritty.yml ${DEST}/.config/alacritty.yml
