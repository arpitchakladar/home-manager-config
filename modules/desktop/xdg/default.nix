# xdg - XDG Desktop Portal configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Hyprland ships its own portal for screensharing/screencasting
  portalPkgs =
    with pkgs;
    [
      xdg-desktop-portal-termfilechooser
    ]
    ++ lib.optionals config.desktop.hyprland.enable [
      xdg-desktop-portal-hyprland
    ]
    ++ lib.optionals (!config.desktop.hyprland.enable) [
      xdg-desktop-portal-gtk
    ];

  defaultPortal = if config.desktop.hyprland.enable then "hyprland" else "gtk";
in
{
  config = lib.mkIf config.desktop.enable {
    xdg.portal = {
      enable = true;
      extraPortals = portalPkgs;
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        default = [ defaultPortal ];
      };
      xdgOpenUsePortal = true;
    };

    home.sessionVariables = {
      GTK_USE_PORTAL = "1";
      TERMCMD = lib.mkIf config.terminal.kitty.enable "${lib.getExe config.terminal.kitty.package} --class file-explorer --title 'Yazi'";
    };
  };
}
