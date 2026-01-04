set -euo pipefail

stop_daemon() {
	if systemctl list-unit-files | grep -q '^warp-svc\.service'; then
		echo "Stopping warp-svc via systemd..."
		sudo systemctl stop warp-svc.service
		return
	fi

	if pgrep -x warp-svc >/dev/null 2>&1; then
		echo "Killing warp-svc process..."
		sudo pkill -x warp-svc
	else
		echo "warp-svc is not running."
	fi
}

disconnect_client() {
	echo "Disconnecting from WARP..."
	if warp-cli status 2>&1 | grep -qi "Connected"; then
		sudo warp-cli disconnect
		echo "Disconnected."
	else
		echo "WARP is already disconnected."
	fi
}

main() {
	disconnect_client
	stop_daemon

	echo "Final status:"
	warp-cli status || true
	sudo systemd-resolve --flush-caches
	sudo systemctl restart systemd-resolved
}

main "$@"
