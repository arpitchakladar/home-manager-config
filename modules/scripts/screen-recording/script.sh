OUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUT_DIR"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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
		echo -e "${YELLOW}Select a window or draw a box...${NC}"
		GEOMETRY=$(slurp)

		if [ -z "$GEOMETRY" ]; then
			echo "Selection cancelled. Exiting."
			exit 1
		fi
	else
		echo -e "${RED}Error: 'slurp' not found.${NC} Recording full screen..."
		sleep 1
	fi
fi

# Start recording
FILENAME="$OUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

echo -e "${GREEN}Recording started!${NC}"
echo -e "Press ${YELLOW}'q'${NC} in this terminal to stop."
echo "File: $FILENAME"
echo "------------------------------------------------"

if [ -n "$GEOMETRY" ]; then
	wf-recorder -g "$GEOMETRY" -f "$FILENAME"
else
	wf-recorder -f "$FILENAME"
fi

echo -e "\n${GREEN}Done!${NC} Video saved to $FILENAME"
