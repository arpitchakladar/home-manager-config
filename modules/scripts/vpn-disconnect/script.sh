PID_FILE="$HOME/.cache/openvpn/vpn.pid"

if [[ ! -f "$PID_FILE" ]]; then
    echo "No VPN PID file found."
    exit 1
fi

PID=$(cat "$PID_FILE")

if ps -p "$PID" > /dev/null 2>&1; then
    echo "Stopping VPN (PID: $PID)..."
    sudo kill "$PID"

    # Wait for clean shutdown
    sleep 2

    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Force killing VPN..."
        sudo kill -9 "$PID"
    fi

    echo "VPN disconnected."
else
    echo "VPN process not running."
fi

rm -f "$PID_FILE"
