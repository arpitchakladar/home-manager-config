# A plugin that adds virtual text support to the nvim-dap.
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.dap-virtual-text = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
