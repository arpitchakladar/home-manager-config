# Colorscheme for mako
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.services.mako.settings = lib.mkIf config.desktop.mako.enable (
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
