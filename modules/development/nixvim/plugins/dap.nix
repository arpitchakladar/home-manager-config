# Debug Adapter Protocol client implementation for Neovim.
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.dap = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
