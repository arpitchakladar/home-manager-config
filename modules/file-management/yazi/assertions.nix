# Validates yazi dependencies and sub-options
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.file-management.yazi.enable || config.terminal.kitty.enable;
      message = ''
        file-management.yazi is enabled but terminal.kitty.enable is not.
        yazi's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
    {
      assertion = !config.file-management.yazi.file-chooser.enable || config.file-management.yazi.enable;
      message = "file-management.yazi.file-chooser.enable requires file-management.yazi.enable.";
    }
  ];
}
