{ config, lib, ... }:

# Noice - Modern UI for Neovim (cmdline, popupmenu, messages)
{
  config.programs.nixvim.plugins.noice = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
