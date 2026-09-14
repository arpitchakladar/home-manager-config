#!/usr/bin/env bash
# Manage a Cloudflare WARP (usque) tunnel: connect, disconnect,
# or report Waybar status.

set -euo pipefail

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

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
  [[ -n "$pid" ]] || return 1
  sudo kill -0 "$pid" 2>/dev/null
}

ensure_config() {
  info "Creating $CONFIG_DIR..."
  mkdir -p "$CONFIG_DIR"
  info "Registering Cloudflare WARP account..."
  usque -c "$CONFIG" register < <(yes)
  if [[ ! -f "$CONFIG" ]]; then
    die "Failed to create config file: $CONFIG"
  fi
  info "Config created successfully."
}

remove_tun_default_routes() {
  local dev="$1"
  while ip route show | grep -qE "^default .*dev $dev"; do
    ROUTE=$(ip route show | grep -E "^default .*dev $dev" | head -n1)
    info "Removing route: $ROUTE"
    sudo ip route del "$ROUTE" || break
  done
}

connect() {
  sudo -v
  ensure_config
  if [[ -f "$PID_FILE" ]]; then
    OLD_PID=$(cat "$PID_FILE")
    if sudo kill -0 "$OLD_PID" 2>/dev/null; then
      die "usque-warp is already running (PID $OLD_PID)"
    else
      info "Removing stale PID file..."
      rm -f "$PID_FILE"
    fi
  fi

  info "Saving current default route..."
  DEFAULT_ROUTE=$(ip route show default | grep -vE 'dev tun[0-9]+' | head -n1)
  if [[ -z "$DEFAULT_ROUTE" ]]; then
    die "Could not determine current default route"
  fi
  echo "$DEFAULT_ROUTE" > "$STATE_FILE"

  info "Recording pre-existing tun interfaces..."
  BEFORE_IFACES=$(list_tun_ifaces)

  info "Starting usque..."
  # sudo does not affect redirects — the outer shell would open "$LOG_FILE"
  # as the unprivileged user. Run the redirection inside sudo (via sh) so the
  # log is opened as root. $$ inside sh is usque's PID (sh exec's usque, keeping
  # the PID stable regardless of how sudo forks internally), written up front.
  sudo sh -c 'echo $$ > "$1"; exec usque nativetun -c "$2" > "$3" 2>&1' \
    _ "$PID_FILE" "$CONFIG" "$LOG_FILE" &

  info "Waiting for MASQUE connection..."
  MASQUE_IP=""
  for _ in {1..30}; do
    MASQUE_IP=$(grep -oP 'MASQUE connection to \K[0-9.]+(?=:443)' "$LOG_FILE" 2>/dev/null || true)
    if [[ -n "$MASQUE_IP" ]]; then
      break
    fi
    sleep 1
  done
  if [[ -z "$MASQUE_IP" ]]; then
    error "Failed to detect MASQUE endpoint"
    sudo kill "$(cat "$PID_FILE")" 2>/dev/null || true
    rm -f "$PID_FILE"
    exit 1
  fi

  info "Waiting for usque interface..."
  TUN_DEV=""
  for _ in {1..30}; do
    AFTER_IFACES=$(list_tun_ifaces)
    TUN_DEV=$(comm -13 <(echo "$BEFORE_IFACES" | sort) <(echo "$AFTER_IFACES" | sort) | head -n1)
    [[ -n "$TUN_DEV" ]] && break
    sleep 1
  done
  if [[ -z "$TUN_DEV" ]]; then
    error "Failed to detect usque interface"
    sudo kill "$(cat "$PID_FILE")" 2>/dev/null || true
    rm -f "$PID_FILE"
    exit 1
  fi
  echo "$TUN_DEV" > "$IFACE_FILE"
  info "Detected interface: $TUN_DEV"

  GATEWAY=$(echo "$DEFAULT_ROUTE" | awk '{for(i=1;i<=NF;i++) if($i=="via") print $(i+1)}')
  INTERFACE=$(echo "$DEFAULT_ROUTE" | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')
  if [[ -z "$GATEWAY" || -z "$INTERFACE" ]]; then
    die "Cannot determine gateway/interface"
  fi
  echo "MASQUE_IP=$MASQUE_IP GATEWAY=$GATEWAY INTERFACE=$INTERFACE" >> "$STATE_FILE"

  info "Allowing MASQUE endpoint outside tunnel..."
  sudo ip route replace \
    "$MASQUE_IP" \
    via "$GATEWAY" \
    dev "$INTERFACE"

  info "Removing old tun routes..."
  remove_tun_default_routes "$TUN_DEV"

  info "Switching default route to $TUN_DEV..."
  sudo ip route add default dev "$TUN_DEV" metric 1
  info "Connected."
}

disconnect() {
  sudo -v
  info "Disconnecting..."
  local dev
  if [[ -f "$IFACE_FILE" ]]; then
    dev=$(cat "$IFACE_FILE")
  else
    dev=$(list_tun_ifaces | head -n1)
  fi

  # Kill usque FIRST so the kernel tears down tun0 (and every route
  # bound to it) as a single atomic operation, instead of us racing
  # it by pulling routes out from under a device that's still up.
  if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    if sudo kill -0 "$PID" 2>/dev/null; then
      info "Stopping usque..."
      sudo kill "$PID" 2>/dev/null || true
      for _ in {1..25}; do
        sudo kill -0 "$PID" 2>/dev/null || break
        sleep 0.2
      done
      if sudo kill -0 "$PID" 2>/dev/null; then
        warn "usque did not stop on SIGTERM, forcing kill..."
        sudo kill -9 "$PID" 2>/dev/null || true
      fi
    fi
    rm -f "$PID_FILE"
  fi

  # Give the kernel a moment to tear the tunnel device down; only touch
  # routes manually if it is not disappearing on its own.
  if [[ -n "${dev:-}" ]]; then
    info "Waiting for tunnel interface to go down..."
    for _ in {1..25}; do
      list_tun_ifaces | grep -qx "$dev" || break
      sleep 0.2
    done
    if list_tun_ifaces | grep -qx "$dev"; then
      warn "interface $dev is still up, cleaning its routes manually..."
      sudo ip route flush dev "$dev" 2>/dev/null || true
      remove_tun_default_routes "$dev"
    fi
  fi

  if [[ -f "$STATE_FILE" ]]; then
    MASQUE_IP=$(grep -oP 'MASQUE_IP=\K[0-9.]+' "$STATE_FILE" || true)
    if [[ -n "$MASQUE_IP" ]]; then
      info "Removing MASQUE route: $MASQUE_IP"
      sudo ip route del "$MASQUE_IP" 2>/dev/null || true
    fi

    # Explicitly restore the pre-connect default route rather than
    # assuming it's still intact. 'replace' is idempotent.
    ORIGINAL_DEFAULT=$(head -n1 "$STATE_FILE")
    if [[ "$ORIGINAL_DEFAULT" == default* ]]; then
      info "Restoring original default route..."
      sudo ip route replace "$ORIGINAL_DEFAULT" \
        || warn "could not restore original default route"
    fi

    rm -f "$STATE_FILE"
  fi

  rm -f "$IFACE_FILE"
  info "Disconnected."
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
    echo "Usage: $0 <connect|disconnect|status>"
    echo ""
    echo "Commands:"
    echo "  connect       Start the WARP tunnel"
    echo "  disconnect    Stop the WARP tunnel and restore routes"
    echo "  status        Print Waybar status JSON"
    exit 1
    ;;
esac