# Validates niri hardware GPU options require desktop to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.desktop.hardware.gpu.nvidia.enable || config.desktop.enable;
      message = "desktop.hardware.gpu.nvidia.enable requires desktop.enable.";
    }
    {
      assertion = !config.desktop.hardware.gpu.amd.enable || config.desktop.enable;
      message = "desktop.hardware.gpu.amd.enable requires desktop.enable.";
    }
  ];
}
