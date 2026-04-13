{
  config,
  pkgs,
  lib,
  ...
}:

# umu-launcher - This is a unified launcher for Windows games on Linux
{
  options.tools.bottles = {
    enable = lib.mkEnableOption "Enables bottles.";
  };

  config = lib.mkIf config.tools.bottles.enable {
    home.packages = with pkgs; [
      umu-launcher
      winetricks
    ];
  };
}
