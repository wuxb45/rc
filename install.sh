#!/bin/bash
echo "install all config files into your HOME."
for cf in $(cat config.list);
do
  echo "$cf -> $HOME/.$cf"
  install "$cf" "$HOME/.$cf"
done

