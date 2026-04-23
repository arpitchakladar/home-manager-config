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
  };

  config = lib.mkIf config.programs.umu-launcher.enable {
    home.packages = with pkgs; [
      umu-launcher
      winetricks
    ];
  };
}
