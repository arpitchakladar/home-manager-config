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

      # Group descriptions for leader prefixes
      spec = [
        {
          __unkeyed-1 = "<leader>g";
          group = "+Git";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "+Find";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "+Debug";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "+LSP";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "+Comment";
        }
      ];
    };
  };
}
