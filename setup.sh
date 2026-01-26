#!/bin/bash

# Kill any existing tmux server
tmux kill-server 2>/dev/null

# Configure tmux to keep window names (only if not already configured)
if [ ! -f ~/.tmux.conf ] || ! grep -q "automatic-rename off" ~/.tmux.conf; then
  echo "set -g automatic-rename off" >> ~/.tmux.conf
  echo "set -g allow-rename off" >> ~/.tmux.conf
fi

# Configure Ctrl+b w to show all sessions with windows in tree view (only if not already configured)
if [ ! -f ~/.tmux.conf ] || ! grep -q "bind-key w choose-tree" ~/.tmux.conf; then
  echo "bind-key w choose-tree -s" >> ~/.tmux.conf
fi

tmux new-session -d -s "installers" -n "Main"

# Pane 1: Update and upgrade
tmux send-keys -t "installers:Main.0" "echo '=== Updating system ===' && sudo apt-get update && sudo apt-get upgrade -y && echo 'DONE_UPDATE' && sleep 2" C-m

# Split and create Pane 2: Install lazygit
tmux split-window -h -t "installers:Main"
tmux send-keys -t "installers:Main.1" "if command -v lazygit &> /dev/null; then echo '=== lazygit already installed ==='; else echo '=== Installing lazygit ===' && LAZYGIT_VERSION=\$(curl -s 'https://api.github.com/repos/jesseduffield/lazygit/releases/latest' | grep -Po '\"tag_name\": *\"v\\K[^\"]*') && curl -Lo lazygit.tar.gz \"https://github.com/jesseduffield/lazygit/releases/download/v\${LAZYGIT_VERSION}/lazygit_\${LAZYGIT_VERSION}_Linux_x86_64.tar.gz\" && tar xf lazygit.tar.gz lazygit && sudo install lazygit -D -t /usr/local/bin/ && rm lazygit.tar.gz lazygit; fi && echo 'DONE_LAZYGIT' && sleep 2" C-m

# Split and create Pane 3: Install opencode
tmux split-window -v -t "installers:Main.0"
tmux send-keys -t "installers:Main.2" "if command -v opencode &> /dev/null; then echo '=== opencode already installed ==='; else echo '=== Installing opencode ===' && npm install -g opencode-ai; fi && echo 'DONE_OPENCODE' && sleep 2" C-m

# Split and create Pane 4: Install btop
tmux split-window -v -t "installers:Main.1"
tmux send-keys -t "installers:Main.3" "if command -v btop &> /dev/null; then echo '=== btop already installed ==='; else echo '=== Installing btop ===' && sudo apt-get install -y btop; fi && echo 'DONE_BTOP' && sleep 2" C-m

# Split and create Pane 5: Install fastfetch
tmux split-window -v -t "installers:Main.2"
tmux send-keys -t "installers:Main.4" "if command -v fastfetch &> /dev/null; then echo '=== fastfetch already installed ==='; else echo '=== Installing fastfetch ===' && sudo apt-get install -y fastfetch; fi && echo 'DONE_FASTFETCH' && sleep 2" C-m

# Add fastfetch to bashrc to run on shell startup
if ! grep -q "fastfetch" ~/.bashrc; then
  echo "fastfetch" >> ~/.bashrc
fi

# Create GH Auth window
tmux new-window -t "installers" -n "GH-Auth"
tmux send-keys -t "installers:GH-Auth" "if gh auth status &> /dev/null; then echo '=== GitHub already authenticated ==='; else echo '=== GitHub Authentication ===' && gh auth login; fi && echo 'DONE_GH_AUTH' && sleep 2" C-m

# Create a monitoring window that will wait for all installations to complete and then kill the session
tmux new-window -t "installers" -n "Monitor"
tmux send-keys -t "installers:Monitor" "echo 'Waiting for all installations to complete...'; while true; do if tmux capture-pane -t installers:Main.0 -p | grep -q 'DONE_UPDATE' && tmux capture-pane -t installers:Main.1 -p | grep -q 'DONE_LAZYGIT' && tmux capture-pane -t installers:Main.2 -p | grep -q 'DONE_OPENCODE' && tmux capture-pane -t installers:Main.3 -p | grep -q 'DONE_BTOP' && tmux capture-pane -t installers:Main.4 -p | grep -q 'DONE_FASTFETCH' && tmux capture-pane -t installers:GH-Auth -p | grep -q 'DONE_GH_AUTH'; then echo 'All installations complete! Switching to general session...'; sleep 3; tmux switch-client -t general; sleep 1; tmux kill-session -t installers; break; fi; sleep 2; done" C-m

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
  else
    # Check for uncommitted changes and pull if clean
    cd "proj/$folder_name"
    if [ -z "$(git status --porcelain)" ]; then
      git pull
    fi
    cd - > /dev/null
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
