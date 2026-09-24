# Validates btop sub-options require the main module to be enabled
{ config, ... }:
let
  cfg = config.system.btop;
in
{
  assertions = [
    {
      assertion = !cfg.nvidia.enable || cfg.enable;
      message = "system.btop.nvidia.enable requires system.btop.enable.";
    }
    {
      assertion = !cfg.amd.enable || cfg.enable;
      message = "system.btop.amd.enable requires system.btop.enable.";
    }
  ];
}
