# Region selector for wlroots Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.slurp = {
    enable = lib.mkEnableOption "Enables slurp.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.slurp;
      description = "The slurp package to use.";
    };
  };

  config = lib.mkIf config.media.slurp.enable {
    home.packages = [ config.media.slurp.package ];
  };
}
