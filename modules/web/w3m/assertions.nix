# Assertions - Validates kitty is enabled for w3m desktop entry
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.web.w3m.enable || config.terminal.kitty.enable;
      message = ''
        web.w3m is enabled but terminal.kitty.enable is not.
        w3m's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
