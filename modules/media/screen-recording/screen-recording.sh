#!/usr/bin/env bash
OUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUT_DIR"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

# Argument parsing
SELECT_MODE=false
while [[ "$#" -gt 0 ]]; do
	case $1 in
		-s|--select) SELECT_MODE=true ;;
	esac
	shift
done

# Geometry selection
GEOMETRY=""

if [ "$SELECT_MODE" = true ]; then
	if command -v slurp >/dev/null 2>&1; then
		info "Select a window or draw a box..."
		GEOMETRY=$(slurp)

		if [ -z "$GEOMETRY" ]; then
			info "Selection cancelled. Exiting."
			exit 1
		fi
	else
		warn "slurp not found. Recording full screen..."
		sleep 1
	fi
fi

# Start recording
FILENAME="$OUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

info "Recording started!"
echo "  Press 'q' in this terminal to stop."
echo "  File: $FILENAME"

if [ -n "$GEOMETRY" ]; then
	wf-recorder -g "$GEOMETRY" -f "$FILENAME"
else
	wf-recorder -f "$FILENAME"
fi

info "Done! Video saved to $FILENAME"