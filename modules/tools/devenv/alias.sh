devenv() {
  local has_reload=false
  local is_shell=false

  for arg in "$@"; do
    if [[ "$arg" == "--reload" || "$arg" == "--no-reload" ]]; then
      has_reload=true
    fi
    if [[ "$arg" == "shell" ]]; then
      is_shell=true
    fi
  done

  if [[ "$is_shell" == true ]]; then
    if [[ "$has_reload" == true ]]; then
      command devenv "$@" "$SHELL"
    else
      command devenv "$@" --no-reload "$SHELL"
    fi
    return
  fi

  if [[ "$has_reload" == true ]]; then
    command devenv "$@"
  else
    command devenv "$@" --no-reload
  fi
}
