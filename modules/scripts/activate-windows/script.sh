#!/usr/bin/env bash

CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/eww-icon-cache.tsv"
mkdir -p "$(dirname "$CACHE_FILE")"
touch "$CACHE_FILE"

APP_DIRS=(
  "$HOME/.local/share/applications"
  "$HOME/.nix-profile/share/applications"
  "/etc/profiles/per-user/$USER/share/applications"
  "/run/current-system/sw/share/applications"
  "$HOME/.local/share/flatpak/exports/share/applications"
  "/var/lib/flatpak/exports/share/applications"
)

ICON_DIRS=(
  "$HOME/.local/share/icons"
  "$HOME/.icons"
  "$HOME/.nix-profile/share/icons"
  "/etc/profiles/per-user/$USER/share/icons"
  "/run/current-system/sw/share/icons"
  "$HOME/.nix-profile/share/pixmaps"
  "/run/current-system/sw/share/pixmaps"
)

find_desktop_file() {
  local id="$1"
  for dir in "${APP_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    local match
    match=$(find "$dir" -maxdepth 1 -iname "${id}.desktop" 2>/dev/null | head -1)
    [ -n "$match" ] && { echo "$match"; return; }
  done
  for dir in "${APP_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    local match
    match=$(grep -ilE "StartupWMClass=${id}$|^Name=${id}$" "$dir"/*.desktop 2>/dev/null | head -1)
    [ -n "$match" ] && { echo "$match"; return; }
  done
}

find_icon_path() {
  local icon_name="$1"
  [ -z "$icon_name" ] && return
  if [[ "$icon_name" == /* ]]; then
    echo "$icon_name"
    return
  fi
  for dir in "${ICON_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    local match
    match=$(find "$dir" -type f \( -iname "${icon_name}.svg" -o -iname "${icon_name}.png" -o -iname "${icon_name}.xpm" \) 2>/dev/null | sort -r | head -1)
    [ -n "$match" ] && { echo "$match"; return; }
  done
}

resolve_icon() {
  local app_id="$1"
  local cached
  cached=$(awk -F'\t' -v k="$app_id" '$1==k{print $2}' "$CACHE_FILE")
  if [ -n "$cached" ]; then
    echo "$cached"
    return
  fi

  local desktop_file icon_name icon_path
  desktop_file=$(find_desktop_file "$app_id")
  if [ -n "$desktop_file" ]; then
    icon_name=$(grep -m1 '^Icon=' "$desktop_file" | cut -d= -f2-)
  fi
  icon_path=$(find_icon_path "$icon_name")
  [ -z "$icon_path" ] && icon_path="$HOME/.config/eww/icons/fallback.svg"

  printf '%s\t%s\n' "$app_id" "$icon_path" >> "$CACHE_FILE"
  echo "$icon_path"
}

ws=$(niri msg -j workspaces)
active_id=$(echo "$ws" | jq '[.[] | select(.is_focused==true)][0].id')

niri msg -j windows | jq -c --argjson wsid "$active_id" \
  '[.[] | select(.workspace_id == $wsid) | {app_id: (.app_id // "unknown"), title: (.title // "")}]' \
  | jq -c '.[]' \
  | while read -r win; do
      app_id=$(jq -r '.app_id' <<< "$win")
      title=$(jq -r '.title' <<< "$win")
      icon=$(resolve_icon "$app_id")
      jq -nc --arg app_id "$app_id" --arg title "$title" --arg icon "$icon" \
        '{app_id: $app_id, title: $title, icon: $icon}'
    done | jq -sc '.'
