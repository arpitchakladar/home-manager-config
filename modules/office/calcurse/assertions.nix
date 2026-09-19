# Validates calcurse sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.office.calcurse.sync.enable || config.office.calcurse.enable;
      message = "office.calcurse.sync.enable requires office.calcurse.enable.";
    }
  ];
}
