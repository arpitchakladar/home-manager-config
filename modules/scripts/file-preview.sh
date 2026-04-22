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
TMP_DIR="/tmp/lf-preview-$(id -u)"
mkdir -p "$TMP_DIR"
TMP_IMG="$TMP_DIR/pv-$(basename "$FILE_PATH" | tr -c '[:alnum:]' '_').png"

# Render image via kitty
render_image() {
  kitten icat --stdin no --transfer-mode memory --place "${w}x${h}@${x}x${y}" "$1" </dev/null >/dev/tty
  exit 1
}

file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

# Ensure file exists
[ ! -r "$FILE_PATH" ] && exit 0

MIMETYPE=$(file --dereference --brief --mime-type "$FILE_PATH")

case "$MIMETYPE" in
  # --- IMAGES ---
  image/svg+xml)
    rsvg-convert "$FILE_PATH" -o "$TMP_IMG" >/dev/null 2>&1 && render_image "$TMP_IMG"
    ;;
  image/*)
    render_image "$FILE_PATH"
    ;;

  # --- VIDEOS ---
  video/*)
    if command -v ffmpegthumbnailer >/dev/null; then
      ffmpegthumbnailer -i "$FILE_PATH" -o "$TMP_IMG" -s 0 -q 5 >/dev/null 2>&1
    else
      "$FFMPEG" -y -i "$FILE_PATH" -ss 00:00:01 -vframes 1 "$TMP_IMG" >/dev/null 2>&1
    fi
    [ -f "$TMP_IMG" ] && render_image "$TMP_IMG"
    ;;

  # --- AUDIO ---
  audio/*)
    "$FFMPEG" -y -i "$FILE_PATH" \
      -filter_complex "showwavespic=s=${WIDTH}x${HEIGHT}:colors=white" \
      -frames:v 1 "$TMP_IMG" >/dev/null 2>&1

    "$FFPROBE" -hide_banner -v quiet -show_format -show_streams "$FILE_PATH"

    [ -f "$TMP_IMG" ] && render_image "$TMP_IMG"
    exit 0
    ;;

  # --- PDF ---
  application/pdf)
    "$PDFTOPPM" -f 1 -l 1 -png -singlefile "$FILE_PATH" "${TMP_IMG%.png}" >/dev/null 2>&1
    [ -f "$TMP_IMG" ] && render_image "$TMP_IMG"
    ;;

  # --- EPUB / MOBI ---
  application/epub+zip|application/x-mobipocket-ebook)
    "$OUCH" decompress "$FILE_PATH" --limit "*/cover*.jpg" --dir /tmp && mv /tmp/cover*.jpg "$TMP_IMG"
    [ -s "$TMP_IMG" ] && render_image "$TMP_IMG"
    ;;

  # --- OFFICE ---
  application/vnd.openxmlformats-officedocument.*|application/msword|application/vnd.oasis.opendocument.*)
    libreoffice --headless --convert-to pdf --outdir "$TMP_DIR" "$FILE_PATH" >/dev/null 2>&1
    PDF_VER="${TMP_DIR}/$(basename "${FILE_PATH%.*}").pdf"
    if [ -f "$PDF_VER" ]; then
        "$PDFTOPPM" -f 1 -l 1 -png -singlefile "$PDF_VER" "${TMP_IMG%.png}" >/dev/null 2>&1
        render_image "$TMP_IMG"
    fi
    ;;

  # --- ARCHIVES ---
  application/zip|application/x-7z-compressed|application/x-rar|application/x-tar|application/x-gzip)
    "$OUCH" list -t "$FILE_PATH" 2>/dev/null
    exit 0
    ;;

  # --- TEXT / CODE ---
  text/*|application/json|application/javascript|application/xml)
    "$BAT" --color=always --style=numbers --line-range :200 "$FILE_PATH"
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

# Always exit cleanly
exit 0
