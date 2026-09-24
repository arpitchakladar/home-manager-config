# Validates niri hardware GPU options require desktop to be enabled
{ config, ... }:
let
  cfg = config.desktop;
in
{
  assertions = [
    {
      assertion = !cfg.hardware.gpu.nvidia.enable || cfg.enable;
      message = "desktop.hardware.gpu.nvidia.enable requires desktop.enable.";
    }
    {
      assertion = !cfg.hardware.gpu.amd.enable || cfg.enable;
      message = "desktop.hardware.gpu.amd.enable requires desktop.enable.";
    }
  ];
}
