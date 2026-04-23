{
  config,
  pkgs,
  lib,
  ...
}:

# Nvtop - GPU process monitor (NVIDIA/AMD/Intel GPUs)
{
  options.programs.nvtop = {
    enable = lib.mkEnableOption "Enables nvtop.";
    package = lib.mkPackageOption pkgs "nvtopPackages.full" { };
  };

  config = lib.mkIf config.programs.nvtop.enable {
    home.packages = [ config.programs.nvtop.package ];
  };
}
