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
    grep -q "^Hidden=true" "$f" && continue
    grep -q "^Type=Application" "$f" || continue
    grep -q "^Terminal=true" "$f" && continue

    categories=$(grep -m1 "^Categories=" "$f" | cut -d= -f2-)
    if [[ -n "$categories" ]]; then
      echo "$categories" | grep -qE "(Settings|System|Screensaver|DesktopSettings|PackageManager)" && continue
    fi

    name=$(grep -m1 "^Name=" "$f" | cut -d= -f2-)
    exec=$(grep -m1 "^Exec=" "$f" | cut -d= -f2-)

    [[ -z "$name" || -z "$exec" ]] && continue

    # Remove field codes properly
    exec=$(echo "$exec" | sed -E 's/ ?%[a-zA-Z]//g')

    entries+="$name"$'\t'"$exec"$'\n'
  done
done

entries=$(printf '%s' "$entries" | sort -fu -t$'\t' -k1,1)

chosen=$(printf '%s' "$entries" | "$FZF" \
  --prompt='Launch: ' \
  --layout=reverse \
  --info=inline \
  --delimiter=$'\t' \
  --with-nth=1)

[[ -z "$chosen" ]] && exit 0

exec_cmd=$(printf '%s' "$chosen" | cut -d$'\t' -f2)

eval "$exec_cmd" &>/dev/null &
disown
