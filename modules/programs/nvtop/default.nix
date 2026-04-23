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
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nvtopPackages.full;
      readOnly = true;
      description = "The nvtop package to use.";
    };
  };

  config = lib.mkIf config.programs.nvtop.enable {
    home.packages = [ config.programs.nvtop.package ];
  };
}
