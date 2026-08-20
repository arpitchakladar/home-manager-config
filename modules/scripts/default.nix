{
  config,
  lib,
  ...
}:
{
  imports = [
    ./deep-clean
    ./gopass-ssh-load
    ./gpg-backup
    ./nix-update
    ./neomutt-sync
    ./screen-recording
    ./system-monitor
    ./usque-warp
    ./yazi-file-chooser
  ];

  config = {
    home.packages = lib.filter (x: x != null) (lib.mapAttrsToList (_: s: s.package) config.scripts);

    xdg.desktopEntries = lib.mapAttrs' (
      name: sc:
      lib.nameValuePair name {
        name = sc.desktop.displayName;
        exec = "${lib.getExe config.terminal.kitty.package} --class ${name} -e ${lib.getExe sc.package}";
        icon = sc.desktop.icon;
        categories = [ "Utility" ];
        terminal = false;
        type = "Application";
      }
    ) (lib.filterAttrs (_: sc: sc.enable && sc.desktop.enable) config.scripts);
  };
}
