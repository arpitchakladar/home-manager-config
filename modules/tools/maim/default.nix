{
  config,
  lib,
  pkgs,
  ...
}:

# Maim - Screenshot utility (slop-based region selection)
{
  options.tools.maim = {
    enable = lib.mkEnableOption "Enables maim.";
  };

  config = lib.mkIf config.tools.maim.enable {
    home.packages = with pkgs; [
      maim
    ];
  };
}
