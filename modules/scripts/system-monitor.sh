# System monitor script using tmux to run bottom and nvtop side-by-side
# Opens a tmux session with:
#   - Left pane: bottom (system/process monitor)
#   - Right pane: nvtop (GPU monitor)
SESSION="system-monitor"

"$KITTY" @ set-font-size -- -4

cleanup() {
  "$KITTY" @ set-font-size -- +4
}
trap cleanup EXIT INT TERM

# Kill any existing session
"$TMUX" kill-session -t "$SESSION" 2>/dev/null

# Start new "$TMUX" session with $BTM wrapped to kill session on exit
"$TMUX" new-session -d -s "$SESSION" -c "$HOME" "bash -c '\"$BTM\"; \"$TMUX\" kill-session -t $SESSION'"

# Split horizontally: right pane runs $NVTOP wrapped similarly
"$TMUX" split-window -h -t "$SESSION:0" -c "$HOME" "bash -c '\"$NVTOP\"; \"$TMUX\" kill-session -t $SESSION'"

"$TMUX" set -g status off
"$TMUX" set -g mouse on
"$TMUX" set -g focus-events on

# Select main pane and attach
"$TMUX" select-pane -t "$SESSION:0.0"
"$TMUX" attach-session -t "$SESSION"
