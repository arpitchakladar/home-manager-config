#!/usr/bin/env sh

# Sync all accounts and immediately tag with notmuch
mbsync -a
notmuch new 2>/dev/null