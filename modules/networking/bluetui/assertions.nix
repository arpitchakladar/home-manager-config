# Validates kitty is enabled for bluetui desktop entry
{ config, ... }:
let
  cfg = config.networking.bluetui;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.terminal.kitty.enable;
      message = ''
        networking.bluetui is enabled but terminal.kitty.enable is not.
        bluetui's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
