# Define directories
CONF_DIR="$HOME/.config/openvpn"
CREDS_DIR="$CONF_DIR/credentials"
SERVERS_DIR="$CONF_DIR/servers"
CACHE_FILE="$HOME/.cache/openvpn/last_connection"

# Create directories
mkdir -p "$CREDS_DIR" "$SERVERS_DIR" "$(dirname "$CACHE_FILE")"

# Logic to force a refresh (bypass cache)
REFRESH=false
if [[ "$1" == "--refresh" || "$1" == "-r" ]]; then
    REFRESH=true
fi

# Try to load from cache
if [[ "$REFRESH" == false && -f "$CACHE_FILE" ]]; then
    source "$CACHE_FILE"
    # Validate cached files still exist
    if [[ ! -f "$CRED" || ! -f "$SERVER" ]]; then
        echo "Cached config not found, falling back to selection..."
        REFRESH=true
    fi
else
    REFRESH=true
fi

# If we need a refresh, run fzf
if [[ "$REFRESH" == true ]]; then
    CRED=$(find "$CREDS_DIR" -type f | fzf --prompt="Select Credentials > ")
    [ -z "$CRED" ] && exit 1

    SERVER=$(find "$SERVERS_DIR" -type f \( -name "*.conf" -o -name "*.ovpn" \) | fzf --prompt="Select VPN Server > ")
    [ -z "$SERVER" ] && exit 1

    # Save to cache
    echo "CRED=\"$CRED\"" > "$CACHE_FILE"
    echo "SERVER=\"$SERVER\"" >> "$CACHE_FILE"
fi

echo "Connecting to $SERVER using $CRED..."

# Execute openvpn
sudo openvpn --config "$SERVER" --auth-user-pass "$CRED"
