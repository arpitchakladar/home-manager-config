# Validates gopass sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.security.gopass.sync.enable || config.security.gopass.enable;
      message = "security.gopass.sync.enable requires security.gopass.enable.";
    }
    {
      assertion = !config.security.gopass.creation-templates.enable || config.security.gopass.enable;
      message = "security.gopass.creation-templates.enable requires security.gopass.enable.";
    }
  ];
}
