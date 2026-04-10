{ config, lib, ... }:

# Tmux - Terminal multiplexer (window/pane management)
{
  options.tools.tmux = {
    enable = lib.mkEnableOption "Enables tmux.";
  };

  config = lib.mkIf config.tools.tmux.enable {
    programs.tmux.enable = true;
  };
}
