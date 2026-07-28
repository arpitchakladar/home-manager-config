#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.cache/usque"
CONFIG="$CONFIG_DIR/config.json"

TUN_DEV="tun0"

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PID_FILE="$RUNTIME_DIR/usque-warp.pid"
STATE_FILE="$RUNTIME_DIR/usque-warp.state"
LOG_FILE="$RUNTIME_DIR/usque-warp.log"


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


remove_tun_default_routes() {
  while ip route show | grep -qE "^default .*dev $TUN_DEV"; do
    ROUTE=$(ip route show | grep -E "^default .*dev $TUN_DEV" | head -n1)

    echo "Removing route: $ROUTE"

    sudo ip route del $ROUTE || true
  done
}


connect() {
  ensure_config

  if [[ -f "$PID_FILE" ]]; then
    OLD_PID=$(cat "$PID_FILE")

    if kill -0 "$OLD_PID" 2>/dev/null; then
      echo "usque-warp is already running (PID $OLD_PID)"
      exit 1
    else
      echo "Removing stale PID file..."
      rm -f "$PID_FILE"
    fi
  fi


  echo "Saving current default route..."

  DEFAULT_ROUTE=$(ip route show default | grep -v "dev $TUN_DEV" | head -n1)

  if [[ -z "$DEFAULT_ROUTE" ]]; then
    echo "Could not determine current default route"
    exit 1
  fi

  echo "$DEFAULT_ROUTE" > "$STATE_FILE"


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

    kill "$(cat "$PID_FILE")" 2>/dev/null || true
    rm -f "$PID_FILE"

    exit 1
  fi


  GATEWAY=$(echo "$DEFAULT_ROUTE" | awk '{for(i=1;i<=NF;i++) if($i=="via") print $(i+1)}')
  INTERFACE=$(echo "$DEFAULT_ROUTE" | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')


  if [[ -z "$GATEWAY" || -z "$INTERFACE" ]]; then
    echo "Cannot determine gateway/interface"
    exit 1
  fi


  echo "$MASQUE_IP $GATEWAY $INTERFACE" >> "$STATE_FILE"


  echo "Allowing MASQUE endpoint outside tunnel..."

  sudo ip route replace \
    "$MASQUE_IP" \
    via "$GATEWAY" \
    dev "$INTERFACE"


  echo "Removing old tun routes..."

  remove_tun_default_routes


  echo "Switching default route to tun0..."

  sudo ip route add default dev "$TUN_DEV" metric 1


  echo "Connected"
}


disconnect() {
  echo "Disconnecting..."

  echo "Removing tun routes..."

  while ip route show | grep -qE "^default .*dev $TUN_DEV"; do
    ROUTE=$(ip route show | grep -E "^default .*dev $TUN_DEV" | head -n1)

    echo "Removing route: $ROUTE"

    sudo ip route del $ROUTE || true
  done


  if [[ -f "$STATE_FILE" ]]; then
    MASQUE_IP=$(grep -oP '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$STATE_FILE" | head -n1 || true)

    if [[ -n "$MASQUE_IP" ]]; then
        echo "Removing MASQUE route: $MASQUE_IP"
        sudo ip route del "$MASQUE_IP" 2>/dev/null || true
    fi

    rm -f "$STATE_FILE"
  fi


  if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")

    if kill -0 "$PID" 2>/dev/null; then
        echo "Stopping usque..."
        sudo kill "$PID" 2>/dev/null || true
    fi

    rm -f "$PID_FILE"
  fi

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
