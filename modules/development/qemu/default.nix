# generic and open source machine and userspace emulator and virtualizer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.qemu;
in
{
  options.development.qemu = {
    enable = lib.mkEnableOption "Enables qemu.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "qemu-bundle";
        paths = [
          pkgs.qemu
          pkgs.libvirt
          pkgs.virtiofsd
          pkgs.virt-manager
        ];
      };
      description = "Bundle of QEMU-related packages.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
