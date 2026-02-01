#!/bin/bash

# Configuration - Edit this path as needed
PROJECT_PATH="coding/proj/galaxyrvr-ctl-web"

# Install Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz
echo "Lazygit Done"

# Install npm packages
npm install -g opencode-ai copilot > /dev/null 2>&1
echo "NPM Packages Done"

# Install btop
sudo apt install btop -y > /dev/null 2>&1
echo "Btop Done"

# Run SSH setup
./ssh.sh
echo "SSH Done"

cd "${PROJECT_PATH}"

# Create new session with window 0 (btop)
tmux new-session -d -s "coding" -n "btop"
tmux send-keys -t "coding:btop" "clear && btop" C-m

# Create window 1 (copilots)
tmux new-window -t "coding:1" -n "copilot"
tmux send-keys -t "coding:copilot.0" "clear && copilot" C-m
tmux split-window -h -t "coding:copilot"
tmux send-keys -t "coding:copilot.1" "clear && copilot" C-m
tmux split-window -v -t "coding:copilot.0"
tmux send-keys -t "coding:copilot.2" "clear && copilot" C-m

# Create window 2 (lazygit)
tmux new-window -t "coding:2" -n "lazygit"
tmux send-keys -t "coding:lazygit" "clear && lazygit" C-m

echo "Tmux Setup Done"

# Switch to the session
tmux switch-client -t "coding"