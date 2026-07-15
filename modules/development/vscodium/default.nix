{
  config,
  lib,
  pkgs,
  ...
}:

# VSCodium - Visual Studio Code fork
{
  options.development.vscodium = {
    enable = lib.mkEnableOption "Enables vscodium.";
  };

  config = lib.mkIf config.development.vscodium.enable {
    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium;
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/vscodium" = "vscodium.desktop";
      "text/plain" = "vscodium.desktop";
    };
  };
}
