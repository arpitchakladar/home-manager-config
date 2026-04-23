{
  config,
  lib,
  pkgs,
  ...
}:

# Maim - Screenshot utility (slop-based region selection)
{
  options.programs.maim = {
    enable = lib.mkEnableOption "Enables maim.";
  };

  config = lib.mkIf config.programs.maim.enable {
    home.packages = with pkgs; [
      maim
    ];
  };
}
