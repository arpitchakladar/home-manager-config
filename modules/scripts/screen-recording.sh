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
# Attempt to get screen resolution using xwininfo, fallback to a safe default if it fails
if command -v xwininfo >/dev/null 2>&1; then
	WIDTH=$(xwininfo -root | grep 'Width:' | awk '{print $2}')
	HEIGHT=$(xwininfo -root | grep 'Height:' | awk '{print $2}')
else
	# Fallback: Try to use a common default or let ffmpeg handle it
	# If xwininfo is missing, we'll just omit -video_size for full screen
	WIDTH=""
	HEIGHT=""
fi

X_OFF=0
Y_OFF=0

if [ "$SELECT_MODE" = true ]; then
	if command -v slop >/dev/null 2>&1; then
		echo -e "${YELLOW}Select a window or draw a box...${NC}"
		read -r WIDTH HEIGHT X_OFF Y_OFF < <(slop -f "%w %h %x %y" --nokeyboard)
		[ -z "$WIDTH" ] && exit 1
	else
		echo -e "${RED}Error: 'slop' is not installed. Cannot select area.${NC}"
		echo "Defaulting to full screen..."
		sleep 1
	fi
fi

# Construct the video size argument only if we have values
SIZE_ARG=""
if [ -n "$WIDTH" ] && [ -n "$HEIGHT" ]; then
	# Ensure even dimensions
	WIDTH=$(( WIDTH + WIDTH % 2 ))
	HEIGHT=$(( HEIGHT + HEIGHT % 2 ))
	SIZE_ARG="-video_size ${WIDTH}x${HEIGHT}"
fi

# --- 3. START RECORDING ---
FILENAME="$OUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

echo -e "${GREEN}Recording started!${NC}"
echo -e "Press ${YELLOW}'q'${NC} in this terminal to stop."
echo "File: $FILENAME"
echo "------------------------------------------------"

# Using ${DISPLAY:-:0} to ensure we have a display target
ffmpeg -hide_banner \
	-f x11grab \
	$SIZE_ARG \
	-framerate 30 \
	-i "${DISPLAY:-:0.0}+${X_OFF},${Y_OFF}" \
	-c:v libx264 \
	-preset ultrafast \
	-crf 23 \
	-pix_fmt yuv420p \
	"$FILENAME"

echo -e "\n${GREEN}Done!${NC} Video saved to $FILENAME"
