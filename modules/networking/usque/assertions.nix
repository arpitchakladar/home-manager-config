# Validates usque sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.networking.usque.warp.enable || config.networking.usque.enable;
      message = "networking.usque.warp.enable requires networking.usque.enable.";
    }
  ];
}
