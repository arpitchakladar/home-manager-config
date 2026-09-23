# Region selector for wlroots Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.media.slurp;
in
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
