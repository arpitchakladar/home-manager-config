{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./aria2-run
    ./deep-clean
    ./file-preview
    ./file-preview-clean
    ./fzf-launcher
    ./i3-keybindings
    ./neomutt-sync
    ./screen-recording
    ./system-monitor
    ./vpn-connect
    ./vpn-disconnect
  ];

  config = {
    home.packages = [
      pkgs.file
      config.terminal.bat.package
    ]
    ++ lib.filter (x: x != null) (lib.mapAttrsToList (_: s: s.package) config.scripts)
    ++ lib.filter (x: x != null) (
      lib.mapAttrsToList (
        name: sc:
        if sc.enable && sc.desktop.enable then
          pkgs.makeDesktopItem {
            name = name;
            desktopName = sc.desktop.displayName;
            exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe sc.package}";
            icon = "kitty";
            categories = [ "Utility" ];
            terminal = false;
            type = "Application";
          }
        else
          null
      ) config.scripts
    );
  };
}
