# Validates gopass sub-options require the main module to be enabled
{ config, ... }:
let
  cfg = config.security.gopass;
in
{
  assertions = [
    {
      assertion = !cfg.sync.enable || cfg.enable;
      message = "security.gopass.sync.enable requires security.gopass.enable.";
    }
    {
      assertion = !cfg.creation-templates.enable || cfg.enable;
      message = "security.gopass.creation-templates.enable requires security.gopass.enable.";
    }
  ];
}
