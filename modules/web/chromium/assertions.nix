# Validates chromium sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.web.chromium.useOpenGL || config.web.chromium.enable;
      message = "web.chromium.useOpenGL requires web.chromium.enable.";
    }
  ];
}
