{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    services.hyprpaper = {
      enable = true;
      package = pkgs.hyprpaper;
      settings = {
        ipc = "on";
        splash = false;
        preload = [ "${../../../assets/sapling.png}" ];
        wallpaper = [
          {
            monitor = "";
            path = "${../../../assets/sapling.png}";
          }
        ];
      };
    };
  };
}
