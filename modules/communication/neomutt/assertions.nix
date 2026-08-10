# Validates NeoMutt dependencies.
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.communication.neomutt.enable || config.development.nixvim.enable;
      message = ''
        communication.neomutt is enabled but development.nixvim.enable is not.
        neomutt uses Neovim as its external pager. Please enable development.nixvim.
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
      assertion = !config.communication.neomutt.enable || config.web.chawan.enable;
      message = ''
        communication.neomutt is enabled but web.chawan.enable is not.
        neomutt uses chawan for HTML email rendering. Please enable web.chawan.
      '';
    }
  ];
}
