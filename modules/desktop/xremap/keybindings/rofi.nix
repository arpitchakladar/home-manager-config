{ pkgs }:

{
  # Application Launchers
  "super-r" = {
    launch = [
      "${pkgs.zsh}/bin/zsh"
      "-c"
      "${pkgs.rofi}/bin/rofi -show drun"
    ];
  };
}
