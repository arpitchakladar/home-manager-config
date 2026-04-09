{ config, lib, ... }:

{
  config.programs.nixvim.plugins.gitsigns = lib.mkIf config.tools.nixvim.enable {
    enable = true;
  };
}
