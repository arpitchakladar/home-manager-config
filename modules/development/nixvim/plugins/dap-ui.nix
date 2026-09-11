# A UI for nvim-dap.
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.dap-ui = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
