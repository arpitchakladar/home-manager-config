nix-shell() {
  for arg in "$@"; do
    if [[ "$arg" == "--run" || "$arg" == "--command" ]]; then
      command nix-shell "$@"
      return
    fi
  done

  command nix-shell "$@" --run "$SHELL"
}

nix() {
  if [[ "$1" == "develop" ]]; then
    local args=("${@:2}")

    for arg in "${args[@]}"; do
      if [[ "$arg" == "-c" || "$arg" == "--command" ]]; then
        command nix "$@"
        return
      fi
    done

    command nix develop "${args[@]}" -c "$SHELL"
  else
    command nix "$@"
  fi
}
