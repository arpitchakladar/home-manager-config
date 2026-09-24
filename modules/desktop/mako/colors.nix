# Colorscheme for mako
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.mako;
in
{
  config.services.mako.settings = lib.mkIf cfg.enable (
    let
      base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
    in
    with base16Colors.colorsWithHashPrefix;
    {
      background-color = base00;
      text-color = base05;
      border-color = base05;
      progress-color = base0C;
    }
  );
}
