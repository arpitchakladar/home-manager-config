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

# Select main pane and attach
tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
