# Validates kitty is enabled for bluetui desktop entry
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.networking.bluetui.enable || config.terminal.kitty.enable;
      message = ''
        networking.bluetui is enabled but terminal.kitty.enable is not.
        bluetui's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
