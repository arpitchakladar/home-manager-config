# Keybindings for kitty
{ config, lib, ... }:
{
  config.programs.kitty.keybindings = lib.mkIf config.terminal.kitty.enable {
    "ctrl+shift+k" = "scroll_line_up";
    "ctrl+shift+j" = "scroll_line_down";
    "ctrl+shift+u" = "scroll_page_up";
    "ctrl+shift+d" = "scroll_page_down";
  };
}
