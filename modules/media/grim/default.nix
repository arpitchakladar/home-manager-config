# Screenshot utility for wlroots Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.grim = {
    enable = lib.mkEnableOption "Enables grim.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.grim;
      description = "The grim package to use.";
    };
  };

  config = lib.mkIf config.media.grim.enable {
    home.packages = [ config.media.grim.package ];
  };
}
