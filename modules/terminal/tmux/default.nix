# Terminal multiplexer
{
  config,
  lib,
  ...
}:
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

  config = lib.mkIf config.terminal.tmux.enable {
    programs.tmux = {
      enable = true;
    };
  };
}
