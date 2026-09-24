# Colorscheme for kitty
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.kitty;
in
{
  config.programs.kitty.settings = lib.mkIf cfg.enable (
    let
      base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
    in
    with base16Colors.colorsWithHashPrefix;
    {
      background = base00;
      foreground = base05;

      color0 = base00;
      color1 = base08;
      color2 = base0B;
      color3 = base0A;
      color4 = base0D;
      color5 = base0E;
      color6 = base0C;
      color7 = base05;
      color8 = base03;
      color9 = base09;
      color10 = base0B;
      color11 = base0A;
      color12 = base0D;
      color13 = base0E;
      color14 = base0F;
      color15 = base07;

      selection_background = base05;
      selection_foreground = base00;
    }
  );
}
