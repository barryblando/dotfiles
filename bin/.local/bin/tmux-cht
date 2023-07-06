#!/bin/bash

languages=$(echo "rust golang typescript" | tr " " "\n")
core_utils=$(echo "find xargs sed awk git" | tr " " "\n")

selected=$(echo -e "$languages\n$core_utils" | fzf)

read -r -p "GIMMIE YOUR QUERY: " query

if echo "$languages" | grep -qs "$selected"; then
  tmux split-window -p 60 -h bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less -R"
else
  tmux split-window -p 60 -h bash -c "curl cht.sh/$selected~$query | less -R"
fi

