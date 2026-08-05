# Validates kitty is enabled for yazi desktop entry
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
  ];
}
