# Timeout protection (prevents hanging)
TIMEOUT=5
if [ -z "$LF_PREVIEW_RUNNING" ]; then
    export LF_PREVIEW_RUNNING=1
    exec timeout "$TIMEOUT" "$0" "$@"
fi

# Parameters from lf
FILE_PATH="$1"
WIDTH="$2"
HEIGHT="$3"
X="$4"
Y="$5"

# Temp dir
TMP_DIR="/tmp/file-preview-$(id -u)"
mkdir -p "$TMP_DIR"

# Unique temp file per actual file using inode
INODE=$(stat -c '%i' "$FILE_PATH" 2>/dev/null || echo "0")

# Render image via kitty
render_image() {
  local file="$1"
  local tries=0
  while [ ! -s "$file" ]; do
    sleep 0.2
    tries=$((tries + 1))
  done
  [ ! -s "$file" ] && exit 0
  kitten icat --stdin no --transfer-mode file --place "${WIDTH}x${HEIGHT}@${X}x${Y}" "$file" </dev/null >/dev/tty
  exit 1
}

# Ensure file exists
[ ! -r "$FILE_PATH" ] && exit 0

MIMETYPE=$(file --dereference --brief --mime-type "$FILE_PATH")
case "$MIMETYPE" in
  # --- IMAGES ---
  image/svg+xml)
    TMP_IMG="$TMP_DIR/svg-${INODE}.png"
    if [ ! -f "$TMP_IMG" ]; then
      rsvg-convert "$FILE_PATH" -o "$TMP_IMG" >/dev/null 2>&1
      [ -s "$TMP_IMG" ] && mv "$TMP_IMG" "$TMP_IMG"
    fi
    render_image "$TMP_IMG"
    ;;

  image/*)
    render_image "$FILE_PATH"
    ;;

  # --- VIDEOS ---
  video/*)
    TMP_IMG="$TMP_DIR/vid-${INODE}.png"
    if [ ! -f "$TMP_IMG" ]; then
      if command -v ffmpegthumbnailer >/dev/null; then
        ffmpegthumbnailer -i "$FILE_PATH" -o "$TMP_IMG" -s 0 -q 5 >/dev/null 2>&1
      else
        ffmpeg -y -i "$FILE_PATH" -ss 00:00:01 -vframes 1 "$TMP_IMG" >/dev/null 2>&1
      fi
    fi
    render_image "$TMP_IMG"
    ;;

  # --- AUDIO ---
  audio/*)
    TMP_IMG="$TMP_DIR/aud-${INODE}.png"
    if [ ! -f "$TMP_IMG" ]; then
      ffmpeg -y -i "$FILE_PATH" \
        -filter_complex "showwavespic=s=${WIDTH}x${HEIGHT}:colors=white" \
        -frames:v 1 "$TMP_IMG" >/dev/null 2>&1
    fi
    ffprobe -hide_banner -v quiet -show_format -show_streams "$FILE_PATH"
    render_image "$TMP_IMG"
    exit 0
    ;;

  # --- PDF ---
  application/pdf)
    TMP_IMG="$TMP_DIR/pdf-${INODE}.png"
    if [ ! -f "$TMP_IMG" ]; then
      pdftoppm -f 1 -l 1 -png -singlefile \
        -scale-to $((WIDTH * 8)) \
        -r 72 \
        "$FILE_PATH" "${TMP_IMG%.png}" >/dev/null 2>&1
    fi
    render_image "$TMP_IMG"
    ;;

  # --- EPUB / MOBI ---
  application/epub+zip|application/x-mobipocket-ebook)
    TMP_IMG="$TMP_DIR/epub-${INODE}.png"
    if [ ! -f "$TMP_IMG" ]; then
      ouch decompress "$FILE_PATH" --limit "*/cover*.jpg" --dir "$TMP_DIR" >/dev/null 2>&1
      mv "$TMP_DIR"/cover*.jpg "$TMP_IMG" 2>/dev/null
    fi
    [ -s "$TMP_IMG" ] && render_image "$TMP_IMG"
    ;;

  # --- OFFICE ---
  application/vnd.openxmlformats-officedocument.*|application/msword|application/vnd.oasis.opendocument.*)
    TMP_IMG="$TMP_DIR/doc-${INODE}.png"
    if [ ! -f "$TMP_IMG" ]; then
      libreoffice --headless --convert-to pdf --outdir "$TMP_DIR" "$FILE_PATH" >/dev/null 2>&1
      PDF_VER="${TMP_DIR}/$(basename "${FILE_PATH%.*}").pdf"
      if [ -f "$PDF_VER" ]; then
        pdftoppm -f 1 -l 1 -png -singlefile "$PDF_VER" "${TMP_IMG%.png}" >/dev/null 2>&1
      fi
    fi
    render_image "$TMP_IMG"
    ;;

  # --- ARCHIVES ---
  application/zip|application/x-7z-compressed|application/x-rar|application/x-tar|application/x-gzip)
    ouch list -t "$FILE_PATH" 2>/dev/null
    exit 0
    ;;

  # --- TEXT / CODE ---
  text/*|application/json|application/javascript|application/xml)
    bat --color=always --style=numbers --line-range :200 "$FILE_PATH" 2>/dev/null
    exit 0
    ;;

  # --- FONTS ---
  font/*|application/vnd.ms-fontobject|application/x-font-ttf)
    fc-scan "$FILE_PATH"
    exit 0
    ;;

  # --- FALLBACK ---
  *)
    file --dereference --brief "$FILE_PATH"
    echo "------------------------------------------------"
    hexdump -C "$FILE_PATH" | head -n 100
    exit 0
    ;;
esac

exit 0
