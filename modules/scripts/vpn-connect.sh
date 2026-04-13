# Define directories
CONF_DIR="$HOME/.config/openvpn"
CREDS_DIR="$CONF_DIR/credentials"
SERVERS_DIR="$CONF_DIR/servers"
CACHE_FILE="$HOME/.cache/openvpn/last_connection"

# Create directories
mkdir -p "$CREDS_DIR" "$SERVERS_DIR" "$(dirname "$CACHE_FILE")"

REFRESH=false
if [[ "$1" == "--refresh" || "$1" == "-r" ]]; then
    REFRESH=true
fi

# Try to load from cache
if [[ "$REFRESH" == false && -f "$CACHE_FILE" ]]; then
    source "$CACHE_FILE"
    if [[ ! -f "$CRED" || ! -f "$SERVER" ]]; then
        REFRESH=true
    fi
else
    REFRESH=true
fi

# Selection logic
if [[ "$REFRESH" == true ]]; then
    CRED=$(find "$CREDS_DIR" -type f | "$FZF" --prompt="Select Credentials > ")
    [ -z "$CRED" ] && exit 1

    SERVER=$(find "$SERVERS_DIR" -type f \( -name "*.conf" -o -name "*.ovpn" \) | "$FZF" --prompt="Select VPN Server > ")
    [ -z "$SERVER" ] && exit 1

    echo "CRED=\"$CRED\"" > "$CACHE_FILE"
    echo "SERVER=\"$SERVER\"" >> "$CACHE_FILE"
fi

echo "Connecting to $SERVER..."

# Create a temporary config file that sudo can read
TMP_CONF=$(mktemp /tmp/vpn-config.XXXXXX)

# Clean the config and save to the temp file
sed -e '/up \/etc\/openvpn\/update-resolv-conf/d' \
    -e '/down \/etc\/openvpn\/update-resolv-conf/d' "$SERVER" > "$TMP_CONF"

# Use a trap to ensure the temp file is deleted when the script exits
# (even if you Ctrl+C)
trap 'rm -f "$TMP_CONF"' EXIT

# Execute openvpn using the temporary file
sudo "$OPENVPN" \
  --config "$TMP_CONF" \
  --auth-user-pass "$CRED" \
  --script-security 2 \
  --up "$SYSTEMD_RESOLVED" \
  --down "$SYSTEMD_RESOLVED" \
  --down-pre
