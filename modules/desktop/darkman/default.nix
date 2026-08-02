# Darkman - Automatic dark/light mode switching based on time of day
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.darkman = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.services.darkman.package;
      description = "The darkman package to use.";
    };
  };

  config = lib.mkIf config.desktop.enable {
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
    systemd.user.services.darkman-set-theme = {
      Unit = {
        Description = "Set Darkman to dark on graphical session startup";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe config.desktop.darkman.package} set dark";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
