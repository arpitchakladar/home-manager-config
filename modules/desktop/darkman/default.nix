# Darkman - Automatic dark/light mode switching based on time of day
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.darkman = {
    enable = lib.mkEnableOption "Enables darkman automatic dark/light mode switching." // {
      default = true;
    };
  };

  config = lib.mkIf (config.desktop.enable && config.desktop.darkman.enable) {
    services.darkman = {
      enable = true;
      settings = {
        portal = true;
        lat = 0;
        lng = 0;
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.common = {
        default = [ "hyprland" ];
        "org.freedesktop.impl.portal.Settings" = "darkman";
      };
    };

    # Always dark by default
    home.activation.forceDarkman = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.darkman}/bin/darkman set dark || true
    '';
  };
}
