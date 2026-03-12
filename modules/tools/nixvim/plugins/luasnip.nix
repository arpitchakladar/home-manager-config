{ config, lib, ... }:

{
  config.programs.nixvim.plugins.luasnip = lib.mkIf config.tools.nixvim.enable {
    enable = true;
  };
}
