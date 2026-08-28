#compdef usque-warp

_arguments \
  '1: :->cmds' \
  '*::arg:->args'

case $state in
  cmds)
    local -a commands
    commands=(
      'connect:Connect to WARP'
      'disconnect:Disconnect from WARP'
      'status:Show connection status'
    )
    _describe 'command' commands
    ;;
esac
