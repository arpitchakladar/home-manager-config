set -euo pipefail

# Optional: where to log the daemon
LOGFILE="/var/log/warp-svc.log"

start_daemon() {
	if ! pgrep -x warp-svc >/dev/null 2>&1; then
		echo "Starting warp-svc daemon..."
		sudo nohup warp-svc >>"$LOGFILE" 2>&1 &
		sleep 2
	else
		echo "warp-svc already running."
	fi
}

is_registered() {
	if warp-cli status 2>&1 | grep -qi "Registration missing"; then
		return 1
	fi
	return 0
}

register_client() {
	echo "Registering client..."
	warp-cli registration new
}

connect_client() {
	echo "Connecting to WARP..."
	warp-cli connect
}

main() {
	start_daemon

	if ! is_registered; then
		register_client
	else
		echo "Client already registered."
	fi

	connect_client

	echo "Current status:"
	warp-cli status
}

main "$@"
