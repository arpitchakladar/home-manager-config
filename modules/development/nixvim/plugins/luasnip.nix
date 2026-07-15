{ config, lib, ... }:

# Luasnip - Snippet engine for Neovim (Lua-based)
{
  config.programs.nixvim.plugins.luasnip = lib.mkIf config.programs.nixvim.enable {
    enable = true;
  };
}
