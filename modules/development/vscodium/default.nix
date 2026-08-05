# Visual Studio Code fork
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.vscodium = {
    enable = lib.mkEnableOption "Enables vscodium.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.vscodium.package;
      description = "The vscodium package to use.";
    };
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
