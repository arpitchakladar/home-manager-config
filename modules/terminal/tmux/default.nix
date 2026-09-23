# Terminal multiplexer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.tmux;
in
{
  options.terminal.tmux = {
    enable = lib.mkEnableOption "Enables tmux.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.tmux.package;
      description = "The tmux package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}
