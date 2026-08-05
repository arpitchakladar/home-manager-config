# Snippet engine for Neovim
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.luasnip = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
