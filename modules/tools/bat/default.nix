{
  config,
  lib,
  ...
}:

# Bluetui - Terminal UI for Bluetooth management
{
  options.tools.bat = {
    enable = lib.mkEnableOption "Enables bat.";
  };

  config = lib.mkIf config.tools.bat.enable {
    programs.bat = {
      enable = true;
    };
  };
}
