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
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "umu-launcher-bundle";
        paths = with pkgs; [
          umu-launcher
          winetricks
        ];
      };
      description = "Bundle of UMU Launcher and winetricks.";
    };
  };

  config = lib.mkIf config.programs.umu-launcher.enable {
    home.packages = [ config.programs.umu-launcher.package ];
  };
}
