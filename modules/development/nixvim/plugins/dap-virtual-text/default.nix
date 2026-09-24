# A plugin that adds virtual text support to the nvim-dap.
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.dap-virtual-text = lib.mkIf cfg.enable {
    enable = true;
  };
}
