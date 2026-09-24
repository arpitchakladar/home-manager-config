# Validates NeoMutt dependencies.
{ config, ... }:
let
  cfg = config.communication.neomutt;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.development.nixvim.enable;
      message = ''
        communication.neomutt is enabled but development.nixvim.enable is not.
        neomutt uses Neovim as its external pager. Please enable development.nixvim.
      '';
    }
    {
      assertion = !cfg.enable || config.terminal.bat.enable;
      message = ''
        communication.neomutt is enabled but terminal.bat.enable is not.
        neomutt requires bat for text/html filtering. Please enable terminal.bat.
      '';
    }
    {
      assertion = !cfg.enable || config.terminal.kitty.enable;
      message = ''
        communication.neomutt is enabled but terminal.kitty.enable is not.
        neomutt's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
    {
      assertion = !cfg.enable || config.web.chawan.enable;
      message = ''
        communication.neomutt is enabled but web.chawan.enable is not.
        neomutt uses chawan for HTML email rendering. Please enable web.chawan.
      '';
    }
  ];
}
