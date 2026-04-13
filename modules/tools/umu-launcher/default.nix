{
  config,
  pkgs,
  lib,
  ...
}:

# umu-launcher - This is a unified launcher for Windows games on Linux
{
  options.tools.umu-launcher = {
    enable = lib.mkEnableOption "Enables umu-launcher.";
  };

  config = lib.mkIf config.tools.umu-launcher.enable {
    home.packages = with pkgs; [
      umu-launcher
      winetricks
    ];
  };
}
