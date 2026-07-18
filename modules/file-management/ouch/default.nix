# Ouch! - CLI tool for compressing and decompressing various formats.
{
  pkgs,
  lib,
  config,
  ...
}:
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

  config = lib.mkIf config.file-management.ouch.enable {
    home.packages = [ config.file-management.ouch.package ];
  };
}
