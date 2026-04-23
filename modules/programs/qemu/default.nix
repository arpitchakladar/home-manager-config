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
    packages = {
      qemu = lib.mkPackageOption pkgs "qemu" { };
      libvirt = lib.mkPackageOption pkgs "libvirt" { };
      virtiofsd = lib.mkPackageOption pkgs "virtiofsd" { };
      virt-manager = lib.mkPackageOption pkgs "virt-manager" { };
    };
  };

  config = lib.mkIf config.programs.qemu.enable {
    home.packages = with config.programs.qemu.packages; [
      qemu
      libvirt
      virtiofsd

      virt-manager
    ];
  };
}
