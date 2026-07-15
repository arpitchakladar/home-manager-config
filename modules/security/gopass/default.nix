# gopass - Standard Unix password manager (Go implementation)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.security.gopass = {
    enable = lib.mkEnableOption "Enables gopass.";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gopass.override { passAlias = true; };
      defaultText = lib.literalExpression "pkgs.gopass.override { passAlias = true; }";
      description = "The gopass package to use.";
    };
  };

  config = lib.mkIf config.security.gopass.enable {
    programs.password-store = {
      enable = true;
      package = config.security.gopass.package;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/pass";
      };
    };
  };
}
