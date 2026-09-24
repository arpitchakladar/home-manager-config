# Validates yazi dependencies and sub-options
{ config, ... }:
let
  cfg = config.file-management.yazi;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.terminal.kitty.enable;
      message = ''
        file-management.yazi is enabled but terminal.kitty.enable is not.
        yazi's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
    {
      assertion = !cfg.file-chooser.enable || cfg.enable;
      message = "file-management.yazi.file-chooser.enable requires file-management.yazi.enable.";
    }
  ];
}
