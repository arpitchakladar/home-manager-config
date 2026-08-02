set -euo pipefail
CONFIG_DIR="$HOME/.cache/usque"
CONFIG="$CONFIG_DIR/config.json"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PID_FILE="$RUNTIME_DIR/usque-warp.pid"
STATE_FILE="$RUNTIME_DIR/usque-warp.state"
IFACE_FILE="$RUNTIME_DIR/usque-warp.iface"
LOG_FILE="$RUNTIME_DIR/usque-warp.log"

list_tun_ifaces() {
  ip -o link show 2>/dev/null | awk -F': ' '{print $2}' | grep -E '^tun[0-9]+$' || true
}

detect_iface() {
  if [[ -f "$IFACE_FILE" ]]; then
    cat "$IFACE_FILE"
    return
  fi
  list_tun_ifaces | head -n1
}

is_running() {
  [[ -f "$PID_FILE" ]] || return 1
  local pid
  pid=$(cat "$PID_FILE" 2>/dev/null || true)
  [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

ensure_config() {
  echo "Creating $CONFIG_DIR..."
  mkdir -p "$CONFIG_DIR"
  rm -f "$CONFIG"
  echo "Registering Cloudflare WARP account..."
  usque -c "$CONFIG" register < <(yes)
  if [[ ! -f "$CONFIG" ]]; then
    echo "Failed to create config file: $CONFIG"
    exit 1
  fi
  echo "Config created successfully."
}

remove_tun_default_routes() {
  local dev="$1"
  while ip route show | grep -qE "^default .*dev $dev"; do
    ROUTE=$(ip route show | grep -E "^default .*dev $dev" | head -n1)
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
  DEFAULT_ROUTE=$(ip route show default | grep -vE 'dev tun[0-9]+' | head -n1)
  if [[ -z "$DEFAULT_ROUTE" ]]; then
    echo "Could not determine current default route"
    exit 1
  fi
  echo "$DEFAULT_ROUTE" > "$STATE_FILE"

  echo "Recording pre-existing tun interfaces..."
  BEFORE_IFACES=$(list_tun_ifaces)

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

  echo "Waiting for usque interface..."
  TUN_DEV=""
  for i in {1..30}; do
    AFTER_IFACES=$(list_tun_ifaces)
    TUN_DEV=$(comm -13 <(echo "$BEFORE_IFACES" | sort) <(echo "$AFTER_IFACES" | sort) | head -n1)
    [[ -n "$TUN_DEV" ]] && break
    sleep 1
  done
  if [[ -z "$TUN_DEV" ]]; then
    echo "Failed to detect usque interface"
    kill "$(cat "$PID_FILE")" 2>/dev/null || true
    rm -f "$PID_FILE"
    exit 1
  fi
  echo "$TUN_DEV" > "$IFACE_FILE"
  echo "Detected interface: $TUN_DEV"

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
  remove_tun_default_routes "$TUN_DEV"

  echo "Switching default route to $TUN_DEV..."
  sudo ip route add default dev "$TUN_DEV" metric 1
  echo "Connected"
}

disconnect() {
  echo "Disconnecting..."
  local dev
  if [[ -f "$IFACE_FILE" ]]; then
    dev=$(cat "$IFACE_FILE")
  else
    dev=$(list_tun_ifaces | head -n1)
  fi

  if [[ -n "${dev:-}" ]]; then
    echo "Removing $dev routes..."
    remove_tun_default_routes "$dev"
  fi

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
  rm -f "$IFACE_FILE"
  echo "Disconnected"
}

status() {
  local iface running=false
  iface=$(detect_iface)
  is_running && running=true

  if [[ -n "$iface" && "$running" == true ]]; then
    printf '{"text":"%s","tooltip":"WARP connected via %s","class":"connected"}\n' "$iface" "$iface"
  elif [[ -n "$iface" ]]; then
    printf '{"text":"%s","tooltip":"Interface %s up, but usque-warp process not tracked","class":"connected"}\n' "$iface" "$iface"
  elif [[ "$running" == true ]]; then
    printf '{"text":"connecting","tooltip":"usque starting...","class":"connecting"}\n'
  else
    printf '{"text":"","tooltip":"WARP disconnected","class":"disconnected"}\n'
  fi
}

case "${1:-}" in
  connect)
    connect
    ;;
  disconnect)
    disconnect
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $0 {connect|disconnect|status}"
    exit 1
    ;;
esac
