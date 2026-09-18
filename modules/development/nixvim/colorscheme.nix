# Base16 theme configuration for nixvim
{
  config,
  lib,
  pkgs,
  ...
}:
let
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
{
  config.programs.nixvim = lib.mkIf config.development.nixvim.enable {
    colorschemes.base16 = {
      enable = true;
      colorscheme = base16Colors.colorsWithHashPrefix;
    };
  };
}
