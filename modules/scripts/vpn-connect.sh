# Define directories
CONF_DIR="$HOME/.config/openvpn"
CREDS_DIR="$CONF_DIR/credentials"
SERVERS_DIR="$CONF_DIR/servers"

# Create directories if they don't exist
mkdir -p "$CREDS_DIR" "$SERVERS_DIR"

# Select the credential file
CRED=$(find "$CREDS_DIR" -type f | fzf --prompt="Select Credentials > ")
[ -z "$CRED" ] && exit 1

# Select the VPN server config
SERVER=$(find "$SERVERS_DIR" -type f \( -name "*.conf" -o -name "*.ovpn" \) | fzf --prompt="Select VPN Server > ")
[ -z "$SERVER" ] && exit 1

echo "Connecting to $SERVER using $CRED..."

# Execute openvpn
sudo openvpn --config "$SERVER" --auth-user-pass "$CRED"
