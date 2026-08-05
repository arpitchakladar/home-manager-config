# Cross-platform graphical process and system monitor
{
  config,
  lib,
  ...
}:
{
  options.system.bottom = {
    enable = lib.mkEnableOption "Enables bottom.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.bottom.package;
      description = "The bottom package to use.";
    };
  };

  config = lib.mkIf config.system.bottom.enable {
    programs.bottom = {
      enable = true;
    };
  };
}
