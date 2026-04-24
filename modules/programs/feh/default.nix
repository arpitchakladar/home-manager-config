{
  config,
  lib,
  pkgs,
  ...
}:

# Feh - Lightweight image viewer and wallpaper setter
{
  config = lib.mkIf config.programs.feh.enable {
    programs.feh = {
      package = pkgs.feh;
    };
  };
}
