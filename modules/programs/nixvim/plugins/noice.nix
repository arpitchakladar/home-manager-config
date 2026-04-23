{ config, lib, ... }:

# Noice - Modern UI for Neovim (cmdline, popupmenu, messages)
{
  config.programs.nixvim.plugins.noice = lib.mkIf config.programs.nixvim.enable {
    enable = true;
    cmdline = {
      enabled = true;
      view = "cmdline_popup";
    };
    popupmenu = {
      enabled = true;
      backend = "cmp";
    };
    presets = {
      command_palette = true;
    };
  };
}
