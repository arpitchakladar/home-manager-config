# Cross-platform graphical process and system monitor
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.btop;
  icons = config.desktop.icons.apps;
in
{
  imports = [ ./assertions.nix ];

  options.system.btop = {
    enable = lib.mkEnableOption "Enables btop.";
    nvidia = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Build btop with NVIDIA GPU monitoring support (CUDA).";
        };
      };
      default = { };
      description = "NVIDIA GPU monitoring configuration.";
    };
    amd = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Build btop with AMD GPU monitoring support (ROCm).";
        };
      };
      default = { };
      description = "AMD GPU monitoring configuration.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.btop.override {
        cudaSupport = cfg.nvidia.enable;
        rocmSupport = cfg.amd.enable;
      };
      description = "The btop package to use.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.btop = {
        enable = true;
        package = cfg.package;
      };
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."btop" = {
        name = "btop++";
        exec = "${lib.getExe config.terminal.kitty.package} --class btop -e ${lib.getExe cfg.package}";
        icon = icons.btop;
        categories = [
          "System"
          "Monitor"
          "ConsoleOnly"
        ];
        comment = "Cross-platform graphical process and system monitor";
        terminal = false;
        type = "Application";
      };
    })
  ];
}
