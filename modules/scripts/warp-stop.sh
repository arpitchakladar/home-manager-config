set -euo pipefail

stop_daemon() {
	echo "Stopping warp-svc process..."

	if pgrep -x warp-svc >/dev/null 2>&1; then
		sudo pkill -x warp-svc
	else
		echo "warp-svc is not running."
		return 0
	fi

	echo "Waiting for warp-svc to stop..."
	for _ in {1..30}; do
		if ! pgrep -x warp-svc >/dev/null 2>&1; then
			echo "warp-svc stopped."
			return 0
		fi
		sleep 1
	done

	echo "ERROR: warp-svc did not stop in time" >&2
	exit 1
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
	[[ "${EUID:-$(id -u)}" -eq 0 ]] || {
		if [[ -t 2 ]]; then
			echo -e "\e[31mERROR:\e[0m Must be run as root" >&2
		else
			echo "ERROR: Must be run as root" >&2
		fi
		exit 1
	}

	disconnect_client
	stop_daemon

	echo "Final status:"
	warp-cli status || true

	echo "Flushing DNS and restarting systemd-resolved..."
	sudo systemd-resolve --flush-caches
	sudo systemctl restart systemd-resolved
}

main "$@"

