# Validates kitty is enabled for impala desktop entry
{ config, ... }:
let
  cfg = config.networking.impala;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.terminal.kitty.enable;
      message = ''
        networking.impala is enabled but terminal.kitty.enable is not.
        impala's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
