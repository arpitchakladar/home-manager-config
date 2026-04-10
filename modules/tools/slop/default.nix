{
  config,
  lib,
  pkgs,
  ...
}:

# Slop - Region selector for screenshots (used by maim/flameshot)
{
  options.tools.slop = {
    enable = lib.mkEnableOption "Enables slop.";
  };

  config = lib.mkIf config.tools.slop.enable {
    home.packages = with pkgs; [
      slop
    ];
  };
}
