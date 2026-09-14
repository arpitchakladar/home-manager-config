# Cross-platform graphical process and system monitor
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.system.btop = {
    enable = lib.mkEnableOption "Enables btop.";
    nvidia.enable = lib.mkEnableOption "Build btop with NVIDIA GPU monitoring support (CUDA).";
    amd.enable = lib.mkEnableOption "Build btop with AMD GPU monitoring support (ROCm).";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.btop.override {
        cudaSupport = config.system.btop.nvidia.enable;
        rocmSupport = config.system.btop.amd.enable;
      };
      description = "The btop package to use.";
    };
  };

  config = lib.mkIf config.system.btop.enable {
    programs.btop = {
      enable = true;
      package = config.system.btop.package;
    };
  };
}
