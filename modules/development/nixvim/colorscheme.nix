# Base16 theme configuration for nixvim
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.nixvim;
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
{
  config.programs.nixvim = lib.mkIf cfg.enable {
    colorschemes.base16 = {
      enable = true;
      colorscheme = base16Colors.colorsWithHashPrefix;
    };
  };
}
