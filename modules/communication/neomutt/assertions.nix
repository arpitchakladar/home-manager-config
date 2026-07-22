# Assertions - Validates neomutt dependencies (less, bat, kitty, w3m) are enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.communication.neomutt.enable || config.terminal.less.enable;
      message = ''
        communication.neomutt is enabled but terminal.less.enable is not.
        neomutt requires less as its pager. Please enable terminal.less.
      '';
    }
    {
      assertion = !config.communication.neomutt.enable || config.terminal.bat.enable;
      message = ''
        communication.neomutt is enabled but terminal.bat.enable is not.
        neomutt requires bat for text/html filtering. Please enable terminal.bat.
      '';
    }
    {
      assertion = !config.communication.neomutt.enable || config.terminal.kitty.enable;
      message = ''
        communication.neomutt is enabled but terminal.kitty.enable is not.
        neomutt's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
    {
      assertion = !config.communication.neomutt.enable || config.web.w3m.enable;
      message = ''
        communication.neomutt is enabled but web.w3m.enable is not.
        neomutt uses w3m for HTML email rendering. Please enable web.w3m.
      '';
    }
  ];
}
