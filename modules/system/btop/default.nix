# Cross-platform graphical process and system monitor
{
  config,
  lib,
  ...
}:
{
  options.system.btop = {
    enable = lib.mkEnableOption "Enables btop.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.btop.package;
      description = "The btop package to use.";
    };
  };

  config = lib.mkIf config.system.btop.enable {
    programs.btop = {
      enable = true;
    };
  };
}
