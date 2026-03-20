PID_FILE="/tmp/ffmpeg-screenrecord.pid"
OUT_DIR="$HOME/Videos/Recordings"

if [ -f "$PID_FILE" ]; then
  kill -INT "$(cat "$PID_FILE")" && rm "$PID_FILE"
  echo "Stopping screen recording"
else
  mkdir -p "$OUT_DIR"
  echo "Starting screen recording"
  ffmpeg \
    -f x11grab \
    -i "$DISPLAY" \
    -framerate 30 \
    -c:v libx264 \
    -preset ultrafast \
    -crf 23 \
    "$OUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
fi
