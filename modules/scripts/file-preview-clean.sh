# Clear kitty icat preview after lf exits
exec kitten icat --clear --stdin no --transfer-mode file </dev/null >/dev/tty
