#!/usr/bin/env bash

# gopass-sync-init
#
# Prepare the gopass password store directory for git-backed syncing.
#
# This runs during home-manager activation. It ensures the store directory
# exists, initializes it as a git repository if it is not already one, and adds
# the configured git remote as `origin` if no remote is set yet. It is a no-op
# (and thus safe to rerun) when the store is already set up.

STORE_DIR="@@PASSWORD_STORE_DIR@@"

mkdir -p "$STORE_DIR"
cd "$STORE_DIR" || { echo "Failed to enter $STORE_DIR"; exit 1; }

# Check if the directory is already a git repository; initialize if not
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Initializing git repository in $STORE_DIR..."
    git init
fi

# Check if the remote 'origin' is set; add it if not
if ! git remote | grep -q "^origin$"; then
    echo "Adding remote origin..."
    git remote add origin "@@REMOTE_REPO_URL@@"
fi

echo "Password store git setup complete."
