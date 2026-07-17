# Luasnip - Snippet engine for Neovim (Lua-based)
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.luasnip = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
