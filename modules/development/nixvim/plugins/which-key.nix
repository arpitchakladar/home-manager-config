# Popup for keybindings
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.which-key = lib.mkIf config.development.nixvim.enable {
    enable = true;
    settings = {
      plugins = {
        marks = true;
        registers = true;
        spelling = {
          enabled = true;
        };
      };
      win = {
        border = "single";
      };
    };
  };
}
