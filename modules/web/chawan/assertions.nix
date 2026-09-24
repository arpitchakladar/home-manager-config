# Validates kitty is enabled for chawan desktop entry
{ config, ... }:
let
  cfg = config.web.chawan;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.terminal.kitty.enable;
      message = ''
        web.chawan is enabled but terminal.kitty.enable is not.
        chawan's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
