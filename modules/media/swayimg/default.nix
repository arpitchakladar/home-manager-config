# Minimalistic document viewer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.media.swayimg;
in
{
  options.media.swayimg = {
    enable = lib.mkEnableOption "Enables swayimg.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.swayimg.package;
      description = "The swayimg package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.swayimg = {
      enable = true;
      initLua = builtins.readFile ./init.lua;
    };

    xdg.mimeApps.defaultApplications = {
      "image/avif" = "swayimg.desktop";
      "image/bmp" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/heic" = "swayimg.desktop";
      "image/heif" = "swayimg.desktop";
      "image/jpeg" = "swayimg.desktop";
      "image/jpg" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
      "image/svg+xml" = "swayimg.desktop";
      "image/tiff" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/x-bmp" = "swayimg.desktop";
      "image/x-png" = "swayimg.desktop";
      "image/x-tga" = "swayimg.desktop";
      "image/x-icon" = "swayimg.desktop";
    };
  };
}
