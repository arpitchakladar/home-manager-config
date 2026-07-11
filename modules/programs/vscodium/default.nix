{
  config,
  lib,
  pkgs,
  ...
}:

# VSCodium - Visual Studio Code fork
{
  config = lib.mkIf config.programs.vscodium.enable {
    programs.vscodium = {
      package = pkgs.vscodium;
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/vscodium" = "vscodium.desktop";
      "text/plain" = "vscodium.desktop";
    };
  };
}
