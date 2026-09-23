# Tools for mounting and unmounting USB and MTP devices
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.file-management.usb;
in
{
  options.file-management.usb = {
    enable = lib.mkEnableOption "Enables USB device mounting tools.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "usb-tools";
        paths = [
          pkgs.udisks
          pkgs.libmtp
          pkgs.glib
        ];
      };
      description = "Bundle of USB/MTP device mounting tools.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
