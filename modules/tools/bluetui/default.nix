{
  config,
  lib,
  pkgs,
  ...
}:

# Bluetui - Terminal UI for Bluetooth management
{
  options.tools.bluetui = {
    enable = lib.mkEnableOption "Enables bluetui.";
  };

  config = lib.mkIf config.tools.bluetui.enable {
    home.packages = with pkgs; [
      bluetui
    ];
  };
}
