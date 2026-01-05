set -euo pipefail

LOGFILE="/var/log/warp-svc.log"
DAEMON_TIMEOUT=30  # seconds

start_daemon() {
	if ! pgrep -x warp-svc >/dev/null 2>&1; then
		echo "Starting warp-svc daemon..."
		sudo nohup warp-svc >>"$LOGFILE" 2>&1 &
	else
		echo "warp-svc already running."
	fi
}

wait_for_daemon() {
	echo "Waiting for warp-svc to become ready..."
	for ((i=1; i<=DAEMON_TIMEOUT; i++)); do
		if warp-cli status >/dev/null 2>&1; then
			echo "warp-svc is ready."
			return 0
		fi
		sleep 1
	done

	echo "ERROR: warp-svc did not become ready within ${DAEMON_TIMEOUT}s" >&2
	exit 1
}

is_registered() {
	if warp-cli status 2>&1 | grep -qi "Registration missing"; then
		return 1
	fi
	return 0
}

register_client() {
	echo "Registering client..."
	sudo warp-cli registration new
}

connect_client() {
	echo "Connecting to WARP..."
	sudo warp-cli connect
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

	start_daemon
	wait_for_daemon

	if ! is_registered; then
		register_client
	else
		echo "Client already registered."
	fi

	connect_client

	echo "Current status:"
	warp-cli status
}

main

