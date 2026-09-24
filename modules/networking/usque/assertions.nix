# Validates usque sub-options require the main module to be enabled
{ config, ... }:
let
  cfg = config.networking.usque;
in
{
  assertions = [
    {
      assertion = !cfg.warp.enable || cfg.enable;
      message = "networking.usque.warp.enable requires networking.usque.enable.";
    }
  ];
}
