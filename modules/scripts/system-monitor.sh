#!/bin/sh
SESSION="system-monitor"

kitty @ set-font-size -- -4

cleanup() {
	kitty @ set-font-size -- +4
}
trap cleanup EXIT INT TERM

# Kill any existing session
tmux kill-session -t "$SESSION" 2>/dev/null

# Start new tmux session with btm wrapped to kill session on exit
tmux new-session -d -s "$SESSION" -c "$HOME" "bash -c 'btm; tmux kill-session -t $SESSION'"

# Split horizontally: right pane runs nvtop wrapped similarly
tmux split-window -h -t "$SESSION:0" -c "$HOME" "bash -c 'nvtop; tmux kill-session -t $SESSION'"

tmux set -g status off
tmux set -g mouse on
tmux set -g focus-events on

# Hover over pane = instant focus
tmux bind -n MouseDown1Pane select-pane -t= \; send-keys -M
tmux bind -n MouseDrag1Pane select-pane -t= \; send-keys -M

# Wheel always works in focused pane
tmux bind -n WheelUpPane select-pane -t= \; send-keys -M
tmux bind -n WheelDownPane select-pane -t= \; send-keys -M

# Select main pane and attach
tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
