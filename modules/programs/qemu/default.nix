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
  };

  config = lib.mkIf config.programs.qemu.enable {
    home.packages = with pkgs; [
      qemu
      libvirt
      virtiofsd

      virt-manager
    ];
  };
}
