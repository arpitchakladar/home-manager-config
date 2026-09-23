# Validates chromium sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.web.chromium.use-opengl || config.web.chromium.enable;
      message = "web.chromium.use-opengl requires web.chromium.enable.";
    }
  ];
}
