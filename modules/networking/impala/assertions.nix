# Validates kitty is enabled for impala desktop entry
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.networking.impala.enable || config.terminal.kitty.enable;
      message = ''
        networking.impala is enabled but terminal.kitty.enable is not.
        impala's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}
