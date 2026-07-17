# Opencode - AI-powered coding assistant (opencode.ai)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.opencode = {
    enable = lib.mkEnableOption "Enables opencode.";
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
