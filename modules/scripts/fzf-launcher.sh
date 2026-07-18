# Fzf-launcher - FZF-based application launcher (scans .desktop files)

DIRS=(
  /run/current-system/sw/share/applications
  "$HOME/.nix-profile/share/applications"
  "$HOME/.local/share/applications"
)

shopt -s nullglob

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
      echo "$categories" | grep -qE "(Settings|Screensaver|DesktopSettings)" && continue
    fi

    name=$(grep -m1 "^Name=" "$f" | cut -d= -f2-)
    if [[ -z "$name" ]]; then
      name=$(grep -m1 -E "^Name\[.*\]=" "$f" | cut -d= -f2-)
    fi
    [[ -z "$name" ]] && continue

    entries+="$name"$'\t'"$f"$'\n'
  done
done

entries=$(printf '%s' "$entries" | sort -fu -t$'\t' -k1,1)

chosen=$(printf '%s' "$entries" | fzf \
  --prompt='Launch: ' \
  --layout=reverse \
  --info=inline \
  --delimiter=$'\t' \
  --with-nth=1)

[[ -z "$chosen" ]] && exit 0

desktop_file=$(printf '%s' "$chosen" | cut -d$'\t' -f2-)

setsid -f dex "$desktop_file" </dev/null >/dev/null 2>&1
