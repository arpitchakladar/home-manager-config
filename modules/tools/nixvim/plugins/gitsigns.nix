{ config, lib, ... }:

# Gitsigns - Git status in the sign column (gitsigns.nvim)
{
  config.programs.nixvim.plugins.gitsigns = lib.mkIf config.tools.nixvim.enable {
    enable = true;
  };
}
