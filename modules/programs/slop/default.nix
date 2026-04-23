{
  config,
  lib,
  pkgs,
  ...
}:

# Slop - Region selector for screenshots (used by maim/flameshot)
{
  options.programs.slop = {
    enable = lib.mkEnableOption "Enables slop.";
  };

  config = lib.mkIf config.programs.slop.enable {
    home.packages = with pkgs; [
      slop
    ];
  };
}
