# Terminal UI for GnuPG
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.gpg-tui = {
    enable = lib.mkEnableOption "Enables gpg-tui.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.gpg-tui;
      description = "The gpg-tui package to use.";
    };
  };

  config = lib.mkIf config.security.gpg-tui.enable {
    home.packages = [ config.security.gpg-tui.package ];
  };
}
