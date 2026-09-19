# Tools for mounting and unmounting USB and MTP devices
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.file-management.usb = {
    enable = lib.mkEnableOption "Enables USB device mounting tools.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "usb-tools";
        paths = [
          pkgs.udisks
          pkgs.simple-mtpfs
        ];
      };
      description = "Bundle of USB/MTP device mounting tools.";
    };
  };

  config = lib.mkIf config.file-management.usb.enable {
    home.packages = [ config.file-management.usb.package ];
  };
}
