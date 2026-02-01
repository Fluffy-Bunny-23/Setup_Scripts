#!/bin/bash

# Kill existing sessions if they exist
for session in General BAI2-Tool Wisher Latin-Flashcard-Trainer Partial-Insanity Hexagonal-Chess xkcdfools; do
    tmux has-session -t "$session" 2>/dev/null && tmux kill-session -t "$session"
done

# General session
tmux new-session -d -s General -n "BTOP"
tmux send-keys -t General:BTOP "btop" C-m

tmux new-window -t General -n "OC"
tmux send-keys -t General:OC "cd /workspaces" C-m
tmux send-keys -t General:OC "opencode" C-m

tmux new-window -t General -n "Bash"
tmux send-keys -t General:Bash "cd /workspaces" C-m
tmux send-keys -t General:Bash "clear" C-m

# BAI2-Tool session
tmux new-session -d -s BAI2-Tool -n "OCa"
tmux send-keys -t BAI2-Tool:OCa "cd BAI2-Tool" C-m
tmux send-keys -t BAI2-Tool:OCa "opencode" C-m

tmux new-window -t BAI2-Tool -n "OCb"
tmux send-keys -t BAI2-Tool:OCb "cd BAI2-Tool" C-m
tmux send-keys -t BAI2-Tool:OCb "opencode" C-m

tmux new-window -t BAI2-Tool -n "LG"
tmux send-keys -t BAI2-Tool:LG "cd BAI2-Tool" C-m
tmux send-keys -t BAI2-Tool:LG "lazygit" C-m

tmux new-window -t BAI2-Tool -n "Serv"
tmux send-keys -t BAI2-Tool:Serv "cd BAI2-Tool" C-m
tmux send-keys -t BAI2-Tool:Serv "npm run dev" C-m

tmux new-window -t BAI2-Tool -n "Bash"
tmux send-keys -t BAI2-Tool:Bash "cd BAI2-Tool" C-m
tmux send-keys -t BAI2-Tool:Bash "clear" C-m

# Wisher session
tmux new-session -d -s Wisher -n "OCa"
tmux send-keys -t Wisher:OCa "cd Wisher" C-m
tmux send-keys -t Wisher:OCa "opencode" C-m

tmux new-window -t Wisher -n "OCb"
tmux send-keys -t Wisher:OCb "cd Wisher" C-m
tmux send-keys -t Wisher:OCb "opencode" C-m

tmux new-window -t Wisher -n "LG"
tmux send-keys -t Wisher:LG "cd Wisher" C-m
tmux send-keys -t Wisher:LG "lazygit" C-m

tmux new-window -t Wisher -n "Serv"
tmux send-keys -t Wisher:Serv "cd Wisher" C-m
tmux send-keys -t Wisher:Serv "python -m http.server 7050" C-m

tmux new-window -t Wisher -n "Bash"
tmux send-keys -t Wisher:Bash "cd Wisher" C-m
tmux send-keys -t Wisher:Bash "clear" C-m

# Latin-Flashcard-Trainer session
tmux new-session -d -s Latin-Flashcard-Trainer -n "OCa"
tmux send-keys -t Latin-Flashcard-Trainer:OCa "cd Latin-Flashcard-Trainer" C-m
tmux send-keys -t Latin-Flashcard-Trainer:OCa "opencode" C-m

tmux new-window -t Latin-Flashcard-Trainer -n "OCb"
tmux send-keys -t Latin-Flashcard-Trainer:OCb "cd Latin-Flashcard-Trainer" C-m
tmux send-keys -t Latin-Flashcard-Trainer:OCb "opencode" C-m

tmux new-window -t Latin-Flashcard-Trainer -n "LG"
tmux send-keys -t Latin-Flashcard-Trainer:LG "cd Latin-Flashcard-Trainer" C-m
tmux send-keys -t Latin-Flashcard-Trainer:LG "lazygit" C-m

tmux new-window -t Latin-Flashcard-Trainer -n "Serv"
tmux send-keys -t Latin-Flashcard-Trainer:Serv "cd Latin-Flashcard-Trainer" C-m
tmux send-keys -t Latin-Flashcard-Trainer:Serv "python -m http.server 7030" C-m

tmux new-window -t Latin-Flashcard-Trainer -n "Bash"
tmux send-keys -t Latin-Flashcard-Trainer:Bash "cd Latin-Flashcard-Trainer" C-m
tmux send-keys -t Latin-Flashcard-Trainer:Bash "clear" C-m

# Partial-Insanity session
tmux new-session -d -s Partial-Insanity -n "OCa"
tmux send-keys -t Partial-Insanity:OCa "cd Partial-Insanity" C-m
tmux send-keys -t Partial-Insanity:OCa "opencode" C-m

tmux new-window -t Partial-Insanity -n "OCb"
tmux send-keys -t Partial-Insanity:OCb "cd Partial-Insanity" C-m
tmux send-keys -t Partial-Insanity:OCb "opencode" C-m

tmux new-window -t Partial-Insanity -n "LG"
tmux send-keys -t Partial-Insanity:LG "cd Partial-Insanity" C-m
tmux send-keys -t Partial-Insanity:LG "lazygit" C-m

tmux new-window -t Partial-Insanity -n "Serv"
tmux send-keys -t Partial-Insanity:Serv "cd Partial-Insanity" C-m
tmux send-keys -t Partial-Insanity:Serv "python -m http.server 2031" C-m

tmux new-window -t Partial-Insanity -n "Bash"
tmux send-keys -t Partial-Insanity:Bash "cd Partial-Insanity" C-m
tmux send-keys -t Partial-Insanity:Bash "clear" C-m

# Hexagonal-Chess session
tmux new-session -d -s Hexagonal-Chess -n "OCa"
tmux send-keys -t Hexagonal-Chess:OCa "cd Hexagonal-Chess" C-m
tmux send-keys -t Hexagonal-Chess:OCa "opencode" C-m

tmux new-window -t Hexagonal-Chess -n "OCb"
tmux send-keys -t Hexagonal-Chess:OCb "cd Hexagonal-Chess" C-m
tmux send-keys -t Hexagonal-Chess:OCb "opencode" C-m

tmux new-window -t Hexagonal-Chess -n "LG"
tmux send-keys -t Hexagonal-Chess:LG "cd Hexagonal-Chess" C-m
tmux send-keys -t Hexagonal-Chess:LG "lazygit" C-m

tmux new-window -t Hexagonal-Chess -n "Serv"
tmux send-keys -t Hexagonal-Chess:Serv "cd Hexagonal-Chess" C-m
tmux send-keys -t Hexagonal-Chess:Serv "python -m http.server 6070" C-m

tmux new-window -t Hexagonal-Chess -n "Bash"
tmux send-keys -t Hexagonal-Chess:Bash "cd Hexagonal-Chess" C-m
tmux send-keys -t Hexagonal-Chess:Bash "clear" C-m

# xkcdfools session
tmux new-session -d -s xkcdfools -n "OCa"
tmux send-keys -t xkcdfools:OCa "cd xkcdfools" C-m
tmux send-keys -t xkcdfools:OCa "opencode" C-m

tmux new-window -t xkcdfools -n "OCb"
tmux send-keys -t xkcdfools:OCb "cd xkcdfools" C-m
tmux send-keys -t xkcdfools:OCb "opencode" C-m

tmux new-window -t xkcdfools -n "LG"
tmux send-keys -t xkcdfools:LG "cd xkcdfools" C-m
tmux send-keys -t xkcdfools:LG "lazygit" C-m

tmux new-window -t xkcdfools -n "Serv"
tmux send-keys -t xkcdfools:Serv "cd xkcdfools/src" C-m
tmux send-keys -t xkcdfools:Serv "python -m http.server 7060" C-m

tmux new-window -t xkcdfools -n "Bash"
tmux send-keys -t xkcdfools:Bash "cd xkcdfools" C-m
tmux send-keys -t xkcdfools:Bash "clear" C-m

# Attach to General session
tmux attach-session -t General
