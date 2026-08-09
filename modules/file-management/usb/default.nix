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
  };

  config = lib.mkIf config.file-management.usb.enable {
    # Tools for manual mounting of usb devices
    home.packages = with pkgs; [
      udisks
      # For MTP devices (like phones)
      simple-mtpfs
    ];
  };
}
