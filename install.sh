#!/bin/bash

# normal .xx files
echo "install all config files into your HOME."
for cf in $(cat config.list);
do
  echo "$cf -> $HOME/.$cf"
  install "$cf" "$HOME/.$cf"
done

# special files
# terminator
echo "terminator-config -> ~/.config/terminator/config"
mkdir -p ~/.config/terminator
cp terminator-config ~/.config/terminator/config
