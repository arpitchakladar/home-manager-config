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
  };

  config = lib.mkIf config.programs.nvtop.enable {
    home.packages = with pkgs; [
      nvtopPackages.full
    ];
  };
}
