#!/bin/bash

# Kill any existing tmux server
tmux kill-server 2>/dev/null

tmux new-session -d -s "installers" -n "Main"

# Pane 1: Update and upgrade
tmux send-keys -t "installers:Main.0" "echo '=== Updating system ===' && sudo apt-get update && sudo apt-get upgrade -y" C-m

# Split and create Pane 2: Install lazygit
tmux split-window -h -t "installers:Main"
tmux send-keys -t "installers:Main.1" "echo '=== Installing lazygit ===' && LAZYGIT_VERSION=\$(curl -s 'https://api.github.com/repos/jesseduffield/lazygit/releases/latest' | grep -Po '\"tag_name\": *\"v\\K[^\"]*') && curl -Lo lazygit.tar.gz \"https://github.com/jesseduffield/lazygit/releases/download/v\${LAZYGIT_VERSION}/lazygit_\${LAZYGIT_VERSION}_Linux_x86_64.tar.gz\" && tar xf lazygit.tar.gz lazygit && sudo install lazygit -D -t /usr/local/bin/ && rm lazygit.tar.gz lazygit" C-m

# Split and create Pane 3: Install opencode
tmux split-window -v -t "installers:Main.0"
tmux send-keys -t "installers:Main.2" "echo '=== Installing opencode ===' && npm install -g opencode-ai" C-m

# Split and create Pane 4: Install btop
tmux split-window -v -t "installers:Main.1"
tmux send-keys -t "installers:Main.3" "echo '=== Installing btop ===' && sudo apt-get install -y btop" C-m

# Create GH Auth window
tmux new-window -t "installers" -n "GH-Auth"
tmux send-keys -t "installers:GH-Auth" "echo '=== GitHub Authentication ===' && gh auth login" C-m

# Create proj directory if not exists
mkdir -p proj

# Read proj.json and create sessions for each project
jq -c '.[]' proj.json | while read -r project; do
  git_url=$(echo "$project" | jq -r '.git_url')
  folder_name=$(echo "$project" | jq -r '.folder_name')
  short_name=$(echo "$project" | jq -r '.short_name')
  server_cmd=$(echo "$project" | jq -r '.server_cmd')

  # Clone repo if not exists in proj directory
  if [ ! -d "proj/$folder_name" ]; then
    git clone "$git_url" "proj/$folder_name"
  fi

  # Create session
  tmux new-session -d -s "$short_name" -n "OCa"

  # OCa pane - opencode
  tmux send-keys -t "$short_name:OCa" "cd proj/$folder_name && opencode" C-m

  # OCb window - opencode
  tmux new-window -t "$short_name" -n "OCb"
  tmux send-keys -t "$short_name:OCb" "cd proj/$folder_name && opencode" C-m

  # LG window - lazygit
  tmux new-window -t "$short_name" -n "LG"
  tmux send-keys -t "$short_name:LG" "cd proj/$folder_name && lazygit" C-m

  # Serv window
  tmux new-window -t "$short_name" -n "Serv"
  tmux send-keys -t "$short_name:Serv" "cd proj/$folder_name && $server_cmd" C-m

  # Bash window
  tmux new-window -t "$short_name" -n "Bash"
  tmux send-keys -t "$short_name:Bash" "cd proj/$folder_name" C-m
done

# Create general session
tmux new-session -d -s "general" -n "0"
tmux send-keys -t "general:0" "btop" C-m

# OCa window - opencode
tmux new-window -t "general" -n "OCa"
tmux send-keys -t "general:OCa" "opencode" C-m

# OCb window - opencode
tmux new-window -t "general" -n "OCb"
tmux send-keys -t "general:OCb" "opencode" C-m

# BASHa window
tmux new-window -t "general" -n "BASHa"

# BASHb window
tmux new-window -t "general" -n "BASHb"

# Attach to the installers session
tmux attach-session -t "installers"
