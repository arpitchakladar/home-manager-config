# AI-powered coding assistant
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.opencode = {
    enable = lib.mkEnableOption "Enables opencode.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.opencode.package;
      description = "The opencode package to use.";
    };
  };

  config = lib.mkIf config.development.opencode.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/opencode" = "opencode.desktop";
    };
  };
}
