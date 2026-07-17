# Noice - Modern UI for Neovim (cmdline, popupmenu, messages)
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.noice = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
