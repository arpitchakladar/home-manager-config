{ config, lib, ... }:

# Noice - Modern UI for Neovim (cmdline, popupmenu, messages)
{
  config.programs.nixvim.plugins.noice = lib.mkIf config.programs.nixvim.enable {
    enable = true;
  };
}
