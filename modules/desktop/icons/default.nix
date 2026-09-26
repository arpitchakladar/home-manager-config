# Icon definitions for Tela-nord-dark theme
{
  config,
  lib,
  ...
}:
let
  cfg = config.desktop;
in
{
  options.desktop.icons = {
    apps = {
      calcurse = lib.mkOption {
        type = lib.types.str;
        default = "calendar";
        description = "Icon for calcurse calendar app";
      };
      git = lib.mkOption {
        type = lib.types.str;
        default = "git";
        description = "Icon for git/lazygit";
      };
      gopass = lib.mkOption {
        type = lib.types.str;
        default = "password-manager";
        description = "Icon for gopass password manager";
      };
      gpg = lib.mkOption {
        type = lib.types.str;
        default = "dialog-password";
        description = "Icon for GPG/gpg-tui";
      };
      browser = lib.mkOption {
        type = lib.types.str;
        default = "internet-web-browser";
        description = "Icon for web browser/chawan";
      };
      opencode = lib.mkOption {
        type = lib.types.str;
        default = "visualstudiocode";
        description = "Icon for opencode";
      };
      systemctl = lib.mkOption {
        type = lib.types.str;
        default = "preferences-system";
        description = "Icon for systemctl-tui";
      };
      neomutt = lib.mkOption {
        type = lib.types.str;
        default = "neomutt";
        description = "Icon for neomutt email client";
      };
      btop = lib.mkOption {
        type = lib.types.str;
        default = "btop";
        description = "Icon for btop system monitor";
      };
      senpai = lib.mkOption {
        type = lib.types.str;
        default = "senpai";
        description = "Icon for senpai IRC client";
      };
      niriPowerOffMonitors = lib.mkOption {
        type = lib.types.str;
        default = "system-shutdown-symbolic";
        description = "Icon for niri poweroff monitors action";
      };
      bluetui = lib.mkOption {
        type = lib.types.str;
        default = "bluetooth-active-symbolic";
        description = "Icon for bluetui bluetooth manager";
      };
      heroic = lib.mkOption {
        type = lib.types.str;
        default = "com.heroicgameslauncher.hgl";
        description = "Icon for heroic games launcher";
      };
      impala = lib.mkOption {
        type = lib.types.str;
        default = "network-wireless-signal-excellent-symbolic";
        description = "Icon for impala wifi manager";
      };
      usqueVpn = lib.mkOption {
        type = lib.types.str;
        default = "network-vpn-symbolic";
        description = "Icon for usque VPN connected";
      };
      usqueVpnDisconnected = lib.mkOption {
        type = lib.types.str;
        default = "network-vpn-disconnected-symbolic";
        description = "Icon for usque VPN disconnected";
      };
      aria2 = lib.mkOption {
        type = lib.types.str;
        default = "folder-download";
        description = "Icon for aria2 download manager";
      };
      aria2Start = lib.mkOption {
        type = lib.types.str;
        default = "media-playback-start-symbolic";
        description = "Icon for aria2 start action";
      };
      aria2Stop = lib.mkOption {
        type = lib.types.str;
        default = "media-playback-stop-symbolic";
        description = "Icon for aria2 stop action";
      };
      yazi = lib.mkOption {
        type = lib.types.str;
        default = "yazi";
        description = "Icon for yazi file manager";
      };
    };

    bar = {
      offline = lib.mkOption {
        type = lib.types.str;
        default = "network-offline";
        description = "Bar icon for offline network";
      };
      wifi = lib.mkOption {
        type = lib.types.str;
        default = "network-wireless";
        description = "Bar icon for wifi network";
      };
      ethernet = lib.mkOption {
        type = lib.types.str;
        default = "network-wired";
        description = "Bar icon for ethernet network";
      };
      vpn = lib.mkOption {
        type = lib.types.str;
        default = "network-vpn";
        description = "Bar icon for VPN network";
      };
      cpu = lib.mkOption {
        type = lib.types.str;
        default = "cpu";
        description = "Bar icon for CPU";
      };
      ram = lib.mkOption {
        type = lib.types.str;
        default = "drive-harddisk";
        description = "Bar icon for RAM";
      };
      battery = lib.mkOption {
        type = lib.types.str;
        default = "battery";
        description = "Bar icon for battery";
      };
      audio = lib.mkOption {
        type = lib.types.str;
        default = "audio-volume-high";
        description = "Bar icon for audio";
      };
      calendar = lib.mkOption {
        type = lib.types.str;
        default = "calendar";
        description = "Bar icon for calendar";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    desktop.icons = {
      apps = {
        calcurse = "calendar";
        git = "git";
        gopass = "password-manager";
        gpg = "dialog-password";
        browser = "internet-web-browser";
        opencode = "visualstudiocode";
        systemctl = "preferences-system";
        neomutt = "neomutt";
        btop = "btop";
        senpai = "senpai";
        niriPowerOffMonitors = "system-shutdown-symbolic";
        bluetui = "bluetooth-active-symbolic";
        heroic = "com.heroicgameslauncher.hgl";
        impala = "network-wireless-signal-excellent-symbolic";
        usqueVpn = "network-vpn-symbolic";
        usqueVpnDisconnected = "network-vpn-disconnected-symbolic";
        aria2 = "folder-download";
        aria2Start = "media-playback-start-symbolic";
        aria2Stop = "media-playback-stop-symbolic";
        yazi = "yazi";
      };

      bar = {
        offline = "network-offline";
        wifi = "network-wireless";
        ethernet = "network-wired";
        vpn = "network-vpn";
        cpu = "cpu";
        ram = "drive-harddisk";
        battery = "battery";
        audio = "audio-volume-high";
        calendar = "calendar";
      };
    };
  };
}
