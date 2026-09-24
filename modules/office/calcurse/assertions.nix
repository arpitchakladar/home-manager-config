# Validates calcurse sub-options require the main module to be enabled
{ config, ... }:
let
  cfg = config.office.calcurse;
in
{
  assertions = [
    {
      assertion = !cfg.sync.enable || cfg.enable;
      message = "office.calcurse.sync.enable requires office.calcurse.enable.";
    }
  ];
}
