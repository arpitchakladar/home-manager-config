# generic and open source machine and userspace emulator and virtualizer
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.qemu = {
    enable = lib.mkEnableOption "Enables qemu.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "qemu-bundle";
        paths = with pkgs; [
          qemu
          libvirt
          virtiofsd
          virt-manager
        ];
      };
      description = "Bundle of QEMU-related packages.";
    };
  };

  config = lib.mkIf config.development.qemu.enable {
    home.packages = [ config.development.qemu.package ];
  };
}
