# Aria2 - command line download manager
{
  lib,
  config,
  ...
}:
{
  options.web.aria2 = {
    enable = lib.mkEnableOption "Enables aria2.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.aria2.package;
      description = "The aria2 package to use.";
    };
  };

  config = lib.mkIf config.web.aria2.enable {
    programs.aria2 = {
      enable = true;
      settings = {
        dir = "${config.home.homeDirectory}/Downloads";
      };
      systemd.enable = true;
    };
  };
}
