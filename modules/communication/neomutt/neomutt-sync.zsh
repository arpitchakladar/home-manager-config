#compdef neomutt-sync
# Zsh completion for the neomutt-sync command.
# Completes mbsync channel names parsed from the mbsyncrc
# (defaults to ~/.config/mbsync/.mbsyncrc, overridable via MBSYNCRC).

_arguments '1: :->channel'

case $state in
  channel)
    local mbsyncrc="${MBSYNCRC:-$HOME/.config/mbsync/.mbsyncrc}"
    local -a channels
    while IFS= read -r channel; do
      case $channel in
        *-quick) channels+=("$channel:Quick sync of INBOX only (new mail); run from the neomutt gs macro") ;;
        *-full)  channels+=("$channel:Full two-way sync of all folders (slow); for scheduled runs") ;;
        *)       channels+=("$channel") ;;
      esac
    done < <(grep -oP '^Channel\s+\K\S+' "$mbsyncrc" 2>/dev/null | sort -u)
    _describe 'channel' channels
    ;;
esac
