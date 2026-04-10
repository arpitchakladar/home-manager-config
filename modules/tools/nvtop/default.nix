{
  config,
  pkgs,
  lib,
  ...
}:

# Nvtop - GPU process monitor (NVIDIA/AMD/Intel GPUs)
{
  options.tools.nvtop = {
    enable = lib.mkEnableOption "Enables nvtop.";
  };

  config = lib.mkIf config.tools.nvtop.enable {
    home.packages = with pkgs; [
      nvtopPackages.full
    ];
  };
}
