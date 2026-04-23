{
  config,
  pkgs,
  lib,
  ...
}:

# umu-launcher - This is a unified launcher for Windows games on Linux
{
  options.programs.umu-launcher = {
    enable = lib.mkEnableOption "Enables umu-launcher.";
    packages = {
      umu-launcher = lib.mkPackageOption pkgs "umu-launcher" { };
      winetricks = lib.mkPackageOption pkgs "winetricks" { };
    };
  };

  config = lib.mkIf config.programs.umu-launcher.enable {
    home.packages = with config.programs.umu-launcher.packages; [
      umu-launcher
      winetricks
    ];
  };
}
