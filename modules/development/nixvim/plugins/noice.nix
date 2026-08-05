# Modern UI for Neovim
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.noice = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
