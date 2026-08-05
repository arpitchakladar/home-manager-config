# Validates kitty is enabled for chawan desktop entry
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.web.chawan.enable || config.terminal.kitty.enable;
      message = ''
        web.chawan is enabled but terminal.kitty.enable is not.
        chawan's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
