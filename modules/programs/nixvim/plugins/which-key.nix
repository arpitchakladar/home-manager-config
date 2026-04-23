{ config, lib, ... }:

# Which-key - Popup for keybindings (which-key.nvim)
{
  config.programs.nixvim.plugins.which-key = lib.mkIf config.programs.nixvim.enable {
    enable = true;
    settings = {
      plugins = {
        marks = true;
        registers = true;
        spelling = {
          enabled = true;
          suggestions = 20;
        };
      };
      win = {
        border = "single";
      };
    };
  };
}
