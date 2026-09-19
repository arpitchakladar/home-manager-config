# Validates btop sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.system.btop.nvidia.enable || config.system.btop.enable;
      message = "system.btop.nvidia.enable requires system.btop.enable.";
    }
    {
      assertion = !config.system.btop.amd.enable || config.system.btop.enable;
      message = "system.btop.amd.enable requires system.btop.enable.";
    }
  ];
}
