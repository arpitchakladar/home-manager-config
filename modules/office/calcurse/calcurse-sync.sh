#!/usr/bin/env bash
#
# Keeps calcurse's data directory in git, so you can back it up / sync
# it across machines via a remote (e.g. a private GitHub repo).
#
# Usage:
#   calcurse-sync init            Turn the calcurse data dir into a git repo
#                                  and (optionally) attach a remote.
#   calcurse-sync sync            Commit any changes and push. Initializes
#                                  the repo automatically on first run.
#   calcurse-sync pull            Pull down changes from the remote.
#   calcurse-sync status          Show git status of the data directory.
#   calcurse-sync remote <url>    Add/update the remote after the fact.
#   calcurse-sync help            Show this message.
#
# Defaults to $XDG_DATA_HOME/calcurse (usually ~/.local/share/calcurse).
# Override with $CALCURSE_DATA_DIR if yours lives elsewhere.

set -euo pipefail

DATA_DIR="${CALCURSE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/calcurse}"
BRANCH="main"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

require_git() {
  command -v git >/dev/null 2>&1 \
    || die "git is not installed or not on PATH. Install it and try again."
}

require_data_dir() {
  if [ ! -d "$DATA_DIR" ]; then
    die "calcurse data directory not found at: $DATA_DIR
Run calcurse at least once so it can create its data files, or set
CALCURSE_DATA_DIR to point at the right location."
  fi
}

require_repo() {
  if [ ! -d "$DATA_DIR/.git" ]; then
    die "no git repository found in $DATA_DIR
Run 'calcurse-sync init' first to set one up."
  fi
}

repo_exists() {
  [ -d "$DATA_DIR/.git" ]
}

has_remote() {
  git -C "$DATA_DIR" remote get-url origin >/dev/null 2>&1
}

has_upstream() {
  git -C "$DATA_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1
}

# e.g. "25th May, 2026 at 12:34 PM"
readable_timestamp() {
  local day suffix month_year time_part

  day=$(date +%-d)
  case "$day" in
    1|21|31) suffix="st" ;;
    2|22)    suffix="nd" ;;
    3|23)    suffix="rd" ;;
    *)       suffix="th" ;;
  esac

  month_year=$(date +"%B, %Y")
  time_part=$(date +"%I:%M %p" | sed 's/^0//')

  printf '%s%s %s at %s' "$day" "$suffix" "$month_year" "$time_part"
}

# Initializes the git repo, makes an initial commit if there's anything to
# commit, and prompts for a remote to push to. Shared by `init` (explicit,
# manual) and `sync` (automatic, first-run-on-a-new-device).
do_init() {
  info "No git repository found in $DATA_DIR — initializing one."
  git -C "$DATA_DIR" init -b "$BRANCH" >/dev/null

  # calcurse sometimes drops lock/swap files in here; keep them out of git
  if [ ! -e "$DATA_DIR/.gitignore" ]; then
    cat > "$DATA_DIR/.gitignore" <<'EOF'
*.lock
*.swp
*.pid
*.log
EOF
  fi

  local remote_url=""
  if [ -t 0 ]; then
    read -r -p "Remote URL to push to (leave blank to skip): " remote_url
  else
    warn "Running non-interactively (e.g. from a calcurse hook) — skipping"
    warn "the remote-URL prompt. Run 'calcurse-sync remote <url>' once you're"
    warn "at a terminal to enable pushing."
  fi

  if [ -n "$remote_url" ]; then
    git -C "$DATA_DIR" remote add origin "$remote_url"
    info "Pushing initial commit to $remote_url"
    if git -C "$DATA_DIR" push -u origin "$BRANCH"; then
      info "Repo initialized and pushed."
    else
      error "Push failed. The remote was still added — check the URL and your"
      error "credentials, then try 'calcurse-sync sync' again."
      exit 1
    fi
  elif [ -t 0 ]; then
    warn "No remote configured. This repo will only track history locally"
    warn "until you run 'calcurse-sync remote <url>'."
  fi
}

cmd_init() {
  require_git
  require_data_dir

  if repo_exists; then
    die "a git repository already exists in $DATA_DIR
If you meant to reconfigure the remote, use 'calcurse-sync remote <url>' instead."
  fi

  do_init
}

cmd_remote() {
  require_git
  require_repo

  local url="${1:-}"
  [ -n "$url" ] || die "usage: calcurse-sync remote <url>"

  if has_remote; then
    git -C "$DATA_DIR" remote set-url origin "$url"
    info "Updated remote 'origin' to $url"
  else
    git -C "$DATA_DIR" remote add origin "$url"
    info "Added remote 'origin' pointing to $url"
  fi
}

cmd_sync() {
  require_git
  require_data_dir

  if ! repo_exists; then
    do_init
    return 0
  fi

  cd "$DATA_DIR"
  git add -A

  if ! git diff --cached --quiet; then
    git commit -m "sync: $(readable_timestamp)" >/dev/null
    info "Committed changes."
  else
    info "No local changes to commit."
  fi

  if ! has_remote; then
    warn "No remote configured for this repo — commit saved locally only."
    warn "Run 'calcurse-sync remote <url>' to enable pushing."
    return 0
  fi

  if has_upstream && [ -z "$(git log '@{u}..HEAD' --oneline)" ]; then
    info "Already up to date with the remote."
    return 0
  fi

  info "Pushing to remote..."
  if has_upstream; then
    push_cmd=(git push)
  else
    push_cmd=(git push -u origin "$BRANCH")
  fi

  if "${push_cmd[@]}"; then
    info "Sync complete."
  else
    status=$?
    error "Push failed."
    error "This usually means the remote has commits you don't have locally"
    error "(e.g. synced from another machine). Run 'calcurse-sync pull'"
    error "to merge them in, then sync again. If that's not it, check your"
    error "network connection and git credentials."
    exit "$status"
  fi
}

cmd_pull() {
  require_git
  require_data_dir
  require_repo

  if ! has_remote; then
    die "no remote configured for this repo.
Run 'calcurse-sync remote <url>' first."
  fi

  cd "$DATA_DIR"

  if [ -n "$(git status --porcelain)" ]; then
    warn "You have uncommitted changes in $DATA_DIR."
    warn "Run 'calcurse-sync sync' first so a pull can't clobber them."
    die "aborting pull to avoid data loss."
  fi

  info "Pulling from remote..."
  if git pull --rebase origin "$BRANCH"; then
    info "Up to date."
  else
    error "Pull failed — likely a merge conflict."
    error "Resolve conflicts manually in $DATA_DIR, then run:"
    error "  git -C \"$DATA_DIR\" rebase --continue"
    error "(or 'git rebase --abort' to back out)."
    exit 1
  fi
}

cmd_status() {
  require_git
  require_data_dir
  require_repo

  git -C "$DATA_DIR" status
}

cmd_help() {
  sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'
}

main() {
  local sub="${1:-help}"
  shift || true

  case "$sub" in
    init)   cmd_init "$@" ;;
    sync)   cmd_sync "$@" ;;
    pull)   cmd_pull "$@" ;;
    status) cmd_status "$@" ;;
    remote) cmd_remote "$@" ;;
    help|-h|--help) cmd_help ;;
    *) die "unknown command: $sub (try 'calcurse-sync help')" ;;
  esac
}

main "$@"
