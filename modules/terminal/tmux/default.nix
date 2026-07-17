# Tmux - Terminal multiplexer (window/pane management)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.terminal.tmux = {
    enable = lib.mkEnableOption "Enables tmux.";
    package = lib.mkPackageOption pkgs "tmux" { };
  };

  config = lib.mkIf config.terminal.tmux.enable {
    programs.tmux = {
      enable = true;
      package = config.terminal.tmux.package;
    };
  };
}
