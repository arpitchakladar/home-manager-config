OUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUT_DIR"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- 1. ARGUMENT PARSING ---
SELECT_MODE=false
while [[ "$#" -gt 0 ]]; do
	case $1 in
		-s|--select) SELECT_MODE=true ;;
	esac
	shift
done

# --- 2. GEOMETRY SELECTION ---
# Default to a standard 1080p fallback if detection fails
WIDTH=1920
HEIGHT=1080
X_OFF=0
Y_OFF=0

# Try to get actual root window size if xwininfo exists
if command -v xwininfo >/dev/null 2>&1; then
	WIDTH=$(xwininfo -root | grep 'Width:' | awk '{print $2}')
	HEIGHT=$(xwininfo -root | grep 'Height:' | awk '{print $2}')
fi

if [ "$SELECT_MODE" = true ]; then
	if command -v slop >/dev/null 2>&1; then
		echo -e "${YELLOW}Select a window or draw a box...${NC}"
		# slop output: 123 456 10 20
		read -r W H X Y < <(slop -f "%w %h %x %y" --nokeyboard)

		if [ -n "$W" ]; then
			WIDTH=$W
			HEIGHT=$H
			X_OFF=$X
			Y_OFF=$Y
		else
			echo "Selection cancelled. Exiting."
			exit 1
		fi
	else
		echo -e "${RED}Error: 'slop' not found.${NC} Recording full screen..."
		sleep 1
	fi
fi

# Ensure even dimensions (FFmpeg/x264 requirement)
WIDTH=$(( WIDTH + WIDTH % 2 ))
HEIGHT=$(( HEIGHT + HEIGHT % 2 ))

# --- 3. START RECORDING ---
FILENAME="$OUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

echo -e "${GREEN}Recording started!${NC}"
echo -e "Press ${YELLOW}'q'${NC} in this terminal to stop."
echo "File: $FILENAME"
echo "------------------------------------------------"

# We pass arguments explicitly here to avoid "Unrecognized option" shell errors
ffmpeg -hide_banner \
	-f x11grab \
	-video_size "${WIDTH}x${HEIGHT}" \
	-framerate 30 \
	-i "${DISPLAY:-:0.0}+${X_OFF},${Y_OFF}" \
	-c:v libx264 \
	-preset ultrafast \
	-crf 23 \
	-pix_fmt yuv420p \
	"$FILENAME"

echo -e "\n${GREEN}Done!${NC} Video saved to $FILENAME"
