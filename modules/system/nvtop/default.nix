# Nvtop - GPU process monitor (NVIDIA/AMD/Intel GPUs)
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.system.nvtop = {
    enable = lib.mkEnableOption "Enables nvtop.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nvtopPackages.full;
      readOnly = true;
      description = "The nvtop package to use.";
    };
  };

  config = lib.mkIf config.system.nvtop.enable {
    home.packages = [ config.system.nvtop.package ];
  };
}
