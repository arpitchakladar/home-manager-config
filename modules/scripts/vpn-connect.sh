CONF_DIR="$HOME/.config/openvpn"
CREDS_DIR="$CONF_DIR/credentials"
SERVERS_DIR="$CONF_DIR/servers"
CACHE_FILE="$HOME/.cache/openvpn/last_connection"
PID_FILE="$HOME/.cache/openvpn/vpn.pid"
LOG_FILE="$HOME/.cache/openvpn/vpn.log"

mkdir -p "$CREDS_DIR" "$SERVERS_DIR" "$(dirname "$CACHE_FILE")"

REFRESH=false
if [[ "$1" == "--refresh" || "$1" == "-r" ]]; then
  REFRESH=true
fi

# Load cache
if [[ "$REFRESH" == false && -f "$CACHE_FILE" ]]; then
  source "$CACHE_FILE"
  if [[ ! -f "$CRED" || ! -f "$SERVER" ]]; then
    REFRESH=true
  fi
else
  REFRESH=true
fi

# Select if needed
if [[ "$REFRESH" == true ]]; then
  CRED=$(find "$CREDS_DIR" -type f | fzf --prompt="Select Credentials > ")
  [ -z "$CRED" ] && exit 1

  SERVER=$(find "$SERVERS_DIR" -type f \( -name "*.conf" -o -name "*.ovpn" \) | fzf --prompt="Select VPN Server > ")
  [ -z "$SERVER" ] && exit 1

  echo "CRED=\"$CRED\"" > "$CACHE_FILE"
  echo "SERVER=\"$SERVER\"" >> "$CACHE_FILE"
fi

echo "Connecting to $SERVER..."

TMP_CONF=$(mktemp /tmp/vpn-config.XXXXXX)

sed -e '/up \/etc\/openvpn\/update-resolv-conf/d' \
  -e '/down \/etc\/openvpn\/update-resolv-conf/d' "$SERVER" > "$TMP_CONF"

# Run in background
sudo -v || exit 1

nohup sudo openvpn \
  --config "$TMP_CONF" \
  --auth-user-pass "$CRED" \
  --script-security 2 \
  --up "$SYSTEMD_RESOLVED_PATH" \
  --down "$SYSTEMD_RESOLVED_PATH" \
  --down-pre \
  > "$LOG_FILE" 2>&1 &

VPN_PID=$!

echo $VPN_PID > "$PID_FILE"
echo "VPN started in background (PID: $VPN_PID)"
echo "Logs: $LOG_FILE"

# Wait until connected
echo -n "Waiting for VPN connection"
while true; do
  if grep -q "Initialization Sequence Completed" "$LOG_FILE" 2>/dev/null; then
    echo ""
    echo "VPN connected successfully."
    break
  fi
  if ! kill -0 "$VPN_PID" 2>/dev/null; then
    echo ""
    echo "VPN process died. Check logs: $LOG_FILE"
    exit 1
  fi
  sleep 1
  echo -n "."
done
