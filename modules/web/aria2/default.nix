# Aria2 - command line download manager
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.web.aria2 = {
    enable = lib.mkEnableOption "Enables aria2.";
    package = lib.mkPackageOption pkgs "aria2" { };
  };

  config = lib.mkIf config.web.aria2.enable {
    programs.aria2 = {
      enable = true;
      package = config.web.aria2.package;
      settings = {
        dir = "${config.home.homeDirectory}/Downloads";
      };
    };
  };
}
