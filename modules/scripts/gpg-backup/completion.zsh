#compdef gpg-backup

_arguments \
  '1: :->cmds' \
  '*::arg:->args'

case $state in
  cmds)
    local -a commands
    commands=(
      'export:Export all GPG keys to a passphrase-protected file'
      'import:Import GPG keys from a backup file'
    )
    _describe 'command' commands
    ;;
  args)
    case $words[1] in
      export|import)
        _files
        ;;
    esac
    ;;
esac
