#!/usr/bin/env bash

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
