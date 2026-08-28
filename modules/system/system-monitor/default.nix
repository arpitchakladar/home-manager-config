# System monitor script using tmux to run bottom and nvtop side-by-side
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkScriptModule;
  script = mkScriptModule {
    scope = [ "system" ];
    name = "system-monitor";
    path = ./system-monitor.sh;
    description = "System monitor script using tmux to run bottom and nvtop side-by-side\nOpens a tmux session with:\n  - Left pane: bottom (system/process monitor)\n  - Right pane: nvtop (GPU monitor)";
    deps = [
      config.system.bottom.package
      config.system.nvtop.package
      config.terminal.tmux.package
      config.terminal.kitty.package
      pkgs.bash
    ];
    desktop = {
      enable = true;
      displayName = "System Monitor";
      icon = "bottom-system-monitor";
    };
    inherit config;
  };
in
{
  options = script.options;
  config = lib.mkMerge [
    script.config
    {
      assertions = import ./assertions.nix { inherit config lib; };
      home.file.".local/share/icons/hicolor/scalable/apps/bottom-system-monitor.svg" = {
        source = ../../../assets/icons/bottom-system-monitor.svg;
      };
    }
  ];
}
