#!/bin/bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-/workspaces}"
PROJ_DIR="${PROJ_DIR:-$WORKSPACE_DIR/proj}"

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required but not installed."
    exit 1
fi

if [ ! -f proj.json ]; then
    echo "proj.json not found."
    exit 1
fi

if ! jq -e '.' proj.json >/dev/null 2>&1; then
    echo "proj.json is not valid JSON."
    exit 1
fi

# Kill existing sessions if they exist
tmux has-session -t General 2>/dev/null && tmux kill-session -t General
while read -r session; do
    tmux has-session -t "$session" 2>/dev/null && tmux kill-session -t "$session"
done < <(jq -r '.[].short_name' proj.json)

# General session
tmux new-session -d -s General -n "BTOP"
tmux send-keys -t General:BTOP "btop" C-m

tmux new-window -t General -n "OC"
tmux send-keys -t General:OC "cd $WORKSPACE_DIR" C-m
tmux send-keys -t General:OC "opencode" C-m

tmux new-window -t General -n "CPa"
tmux send-keys -t General:CPa "cd $WORKSPACE_DIR" C-m
tmux send-keys -t General:CPa "copilot" C-m

tmux new-window -t General -n "CPb"
tmux send-keys -t General:CPb "cd $WORKSPACE_DIR" C-m
tmux send-keys -t General:CPb "copilot" C-m

tmux new-window -t General -n "Bash"
tmux send-keys -t General:Bash "cd $WORKSPACE_DIR" C-m
tmux send-keys -t General:Bash "clear" C-m

# Project sessions
while IFS=$'\t' read -r folder_name short_name server_cmd; do
    tmux new-session -d -s "$short_name" -n "OCa"
    tmux send-keys -t "$short_name:OCa" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:OCa" "opencode" C-m

    tmux new-window -t "$short_name" -n "OCb"
    tmux send-keys -t "$short_name:OCb" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:OCb" "opencode" C-m

    tmux new-window -t "$short_name" -n "CPa"
    tmux send-keys -t "$short_name:CPa" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:CPa" "copilot" C-m

    tmux new-window -t "$short_name" -n "CPb"
    tmux send-keys -t "$short_name:CPb" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:CPb" "copilot" C-m

    tmux new-window -t "$short_name" -n "LG"
    tmux send-keys -t "$short_name:LG" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:LG" "lazygit" C-m

    tmux new-window -t "$short_name" -n "Serv"
    tmux send-keys -t "$short_name:Serv" "cd $PROJ_DIR/$folder_name" C-m
    if [ -n "$server_cmd" ] && [ "$server_cmd" != "null" ]; then
        tmux send-keys -t "$short_name:Serv" "$server_cmd" C-m
    fi

    tmux new-window -t "$short_name" -n "Bash"
    tmux send-keys -t "$short_name:Bash" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:Bash" "clear" C-m
done < <(jq -r '.[] | [.folder_name, .short_name, .server_cmd] | @tsv' proj.json)

# Attach to General session
tmux attach-session -t General
