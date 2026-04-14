DIRS=(
  /run/current-system/sw/share/applications
  "$HOME/.nix-profile/share/applications"
  "$HOME/.local/share/applications"
)

entries=""

for dir in "${DIRS[@]}"; do
  [[ -d "$dir" ]] || continue
  for f in "$dir"/*.desktop; do
    [[ -f "$f" ]] || continue

    grep -q "^NoDisplay=true" "$f" && continue
    grep -q "^Hidden=true"    "$f" && continue

    # only keep Type=Application entries
    grep -q "^Type=Application" "$f" || continue

    # skip terminal-only apps (no GUI window)
    grep -q "^Terminal=true"   "$f" && continue

    # skip entries that are purely settings/mime handlers/background services
    categories=$(grep -m1 "^Categories=" "$f" | cut -d= -f2-)
    if [[ -n "$categories" ]]; then
      echo "$categories" | grep -qE "(Settings|System|Screensaver|DesktopSettings|PackageManager)" && continue
    fi

    name=$(grep -m1 "^Name=" "$f" | cut -d= -f2-)
    exec=$(grep -m1 "^Exec=" "$f" | cut -d= -f2-)

    [[ -z "$name" || -z "$exec" ]] && continue

    exec=$(echo "$exec" | sed 's/ %[fFuUickdDnNvm]//g')

    entries+="$name"$'\t'"$exec"$'\n'
  done
done

chosen=$(printf '%s' "$entries" | sort -f -t$'\t' -k1,1 | "$FZF" \
  --prompt='Launch: ' \
  --layout=reverse \
  --info=inline \
  --with-nth=1 \
  --delimiter=$'\t')

[[ -z "$chosen" ]] && exit 0

exec_cmd=$(printf '%s' "$chosen" | cut -d$'\t' -f2)
setsid bash -c "$exec_cmd" &>/dev/null &
disown
