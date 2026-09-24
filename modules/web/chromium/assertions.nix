# Validates chromium sub-options require the main module to be enabled
{ config, ... }:
let
  cfg = config.web.chromium;
in
{
  assertions = [
    {
      assertion = !cfg.use-opengl || cfg.enable;
      message = "web.chromium.use-opengl requires web.chromium.enable.";
    }
  ];
}
