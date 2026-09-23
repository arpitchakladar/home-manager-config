# CLI tool for compressing and decompressing various formats
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.file-management.ouch;
in
{
  options.file-management.ouch = {
    enable = lib.mkEnableOption "Enables ouch.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ouch.override {
        enableUnfree = true;
      };
      defaultText = lib.literalExpression "pkgs.ouch.override { enableUnfree = true; }";
      description = "The Ouch package to use, with unRAR support enabled.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
