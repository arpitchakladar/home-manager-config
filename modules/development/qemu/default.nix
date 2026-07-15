{
  config,
  lib,
  pkgs,
  ...
}:

# QEMU - generic and open source machine & userspace emulator and virtualizer.
{
  options.programs.qemu = {
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

  config = lib.mkIf config.programs.qemu.enable {
    home.packages = [ config.programs.qemu.package ];
  };
}
