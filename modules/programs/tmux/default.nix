{
  config,
  lib,
  pkgs,
  ...
}:

# Tmux - Terminal multiplexer (window/pane management)
{
  config = lib.mkIf config.programs.tmux.enable {
    programs.tmux = {
      package = pkgs.tmux;
    };
  };
}
