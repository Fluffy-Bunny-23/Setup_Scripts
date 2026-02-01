#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspaces}"
PROJ_DIR="${PROJ_DIR:-${WORKSPACE_DIR}/proj}"
PROJ_FILE="${PROJ_FILE:-$SCRIPT_DIR/proj.json}"

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required but not installed. Install it (e.g., sudo apt-get install -y jq)."
    exit 1
fi

if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux is required but not installed. Install it (e.g., sudo apt-get install -y tmux)."
    exit 1
fi

if [ ! -f "$PROJ_FILE" ]; then
    echo "File not found at $PROJ_FILE. Place proj.json there or set PROJ_FILE to a custom path."
    exit 1
fi

if ! jq -e '.' "$PROJ_FILE" >/dev/null 2>&1; then
    echo "File at $PROJ_FILE is not valid JSON. Try: jq . \"$PROJ_FILE\""
    exit 1
fi

# Kill existing sessions if they exist
tmux has-session -t General 2>/dev/null && tmux kill-session -t General
while read -r session; do
    tmux has-session -t "$session" 2>/dev/null && tmux kill-session -t "$session"
done < <(jq -r '.[].short_name' "$PROJ_FILE")

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
done < <(jq -r '.[] | [.folder_name, .short_name, .server_cmd] | @tsv' "$PROJ_FILE")

# Attach to General session
tmux attach-session -t General
