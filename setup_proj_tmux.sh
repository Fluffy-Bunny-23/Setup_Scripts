#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspaces}"
PROJ_DIR="${PROJ_DIR:-${WORKSPACE_DIR}/proj}"
PROJ_FILE="${PROJ_FILE:-$SCRIPT_DIR/proj.json}"
GENERAL_SESSION="${GENERAL_SESSION:-General}"

kill_session_if_exists() {
    tmux has-session -t "$1" 2>/dev/null && tmux kill-session -t "$1"
}

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required but not installed. Install it (apt-get install jq, brew install jq, etc.)."
    exit 1
fi

if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux is required but not installed. Install it (apt-get install tmux, brew install tmux, etc.)."
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
kill_session_if_exists "$GENERAL_SESSION"
while read -r session; do
    kill_session_if_exists "$session"
done < <(jq -r '.[].short_name' "$PROJ_FILE" || {
    echo "Failed to read sessions from $PROJ_FILE (missing or invalid short_name fields)."
    exit 1
})

# Ensure all project directories exist before creating sessions.
missing_dirs=()
while IFS=$'\t' read -r folder_name _short_name _server_cmd; do
    if [ ! -d "$PROJ_DIR/$folder_name" ]; then
        missing_dirs+=("$PROJ_DIR/$folder_name")
    fi
done < <(jq -r '.[] | [.folder_name, .short_name, (.server_cmd // "")] | @tsv' "$PROJ_FILE")

if [ "${#missing_dirs[@]}" -gt 0 ]; then
    printf "Project directories not found:\n"
    printf "  %s\n" "${missing_dirs[@]}"
    exit 1
fi

# General session
tmux new-session -d -s "$GENERAL_SESSION" -n "BTOP"
tmux send-keys -t "$GENERAL_SESSION:BTOP" "btop" C-m

tmux new-window -t "$GENERAL_SESSION" -n "OC"
tmux send-keys -t "$GENERAL_SESSION:OC" "cd $WORKSPACE_DIR" C-m
tmux send-keys -t "$GENERAL_SESSION:OC" "opencode" C-m

tmux new-window -t "$GENERAL_SESSION" -n "CPa"
tmux send-keys -t "$GENERAL_SESSION:CPa" "cd $WORKSPACE_DIR" C-m
tmux send-keys -t "$GENERAL_SESSION:CPa" "copilot" C-m

tmux new-window -t "$GENERAL_SESSION" -n "CPb"
tmux send-keys -t "$GENERAL_SESSION:CPb" "cd $WORKSPACE_DIR" C-m
tmux send-keys -t "$GENERAL_SESSION:CPb" "copilot" C-m

tmux new-window -t "$GENERAL_SESSION" -n "Bash"
tmux send-keys -t "$GENERAL_SESSION:Bash" "cd $WORKSPACE_DIR" C-m
tmux send-keys -t "$GENERAL_SESSION:Bash" "clear" C-m

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
    if [ -n "$server_cmd" ]; then
        tmux send-keys -t "$short_name:Serv" "$server_cmd" C-m
    fi

    tmux new-window -t "$short_name" -n "Bash"
    tmux send-keys -t "$short_name:Bash" "cd $PROJ_DIR/$folder_name" C-m
    tmux send-keys -t "$short_name:Bash" "clear" C-m
done < <(jq -r '.[] | [.folder_name, .short_name, (.server_cmd // "")] | @tsv' "$PROJ_FILE")

# Attach to General session
tmux attach-session -t "$GENERAL_SESSION"
