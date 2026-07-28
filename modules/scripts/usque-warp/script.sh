set -euo pipefail

CONFIG_DIR="$HOME/.cache/usque"
CONFIG="$CONFIG_DIR/config.json"

TUN_DEV="tun0"
PID_FILE="/tmp/usque-warp.pid"
STATE_FILE="/tmp/usque-warp.state"
LOG_FILE="/tmp/usque-warp.log"


ensure_config() {
  if [[ -f "$CONFIG" ]]; then
    return
  fi

  echo "usque config not found."
  echo "Creating $CONFIG_DIR..."

  mkdir -p "$CONFIG_DIR"

  echo "Registering Cloudflare WARP account..."
  usque register

  echo "Generating usque config..."
  usque generate -o "$CONFIG"

  if [[ ! -f "$CONFIG" ]]; then
    echo "Failed to create config file: $CONFIG"
    exit 1
  fi

  echo "Config created successfully."
}


connect() {
  ensure_config

  if [[ -f "$PID_FILE" ]]; then
    echo "usque-warp is already running"
    exit 1
  fi

  echo "Starting usque..."

  sudo usque nativetun -c "$CONFIG" >"$LOG_FILE" 2>&1 &
  echo $! > "$PID_FILE"

  echo "Waiting for MASQUE connection..."

  MASQUE_IP=""

  for i in {1..30}; do
    MASQUE_IP=$(grep -oP 'MASQUE connection to \K[0-9.]+(?=:443)' "$LOG_FILE" 2>/dev/null || true)

    if [[ -n "$MASQUE_IP" ]]; then
        break
    fi

    sleep 1
done

  if [[ -z "$MASQUE_IP" ]]; then
    echo "Failed to detect MASQUE endpoint"
    kill "$(cat "$PID_FILE")" || true
    rm "$PID_FILE"
    exit 1
  fi

  DEFAULT_ROUTE=$(ip route show default | head -n1)

  GATEWAY=$(echo "$DEFAULT_ROUTE" | awk '{for(i=1;i<=NF;i++) if($i=="via") print $(i+1)}')
  INTERFACE=$(echo "$DEFAULT_ROUTE" | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')

  if [[ -z "$GATEWAY" || -z "$INTERFACE" ]]; then
    echo "Cannot determine gateway"
    exit 1
  fi

  echo "$GATEWAY $INTERFACE $MASQUE_IP" > "$STATE_FILE"

  echo "Allowing MASQUE endpoint outside tunnel..."
  sudo ip route replace "$MASQUE_IP" via "$GATEWAY" dev "$INTERFACE"

  echo "Switching default route to tun0..."
  sudo ip route replace default dev "$TUN_DEV" metric 1

  echo "Connected"
}


disconnect() {
  echo "Disconnecting..."

  if [[ -f "$STATE_FILE" ]]; then
    read GATEWAY INTERFACE MASQUE_IP < "$STATE_FILE"

    echo "Restoring normal route..."

    sudo ip route replace default via "$GATEWAY" dev "$INTERFACE"

    sudo ip route del "$MASQUE_IP" 2>/dev/null || true

    rm "$STATE_FILE"
  fi

  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null || true
    rm "$PID_FILE"
  fi

  sudo ip route del default dev "$TUN_DEV" 2>/dev/null || true

  echo "Disconnected"
}


case "${1:-}" in
  connect)
    connect
    ;;
  disconnect)
    disconnect
    ;;
  *)
    echo "Usage: $0 {connect|disconnect}"
    exit 1
    ;;
esac
