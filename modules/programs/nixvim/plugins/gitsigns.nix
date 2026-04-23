{ config, lib, ... }:

# Gitsigns - Git status in the sign column (gitsigns.nvim)
{
  config.programs.nixvim.plugins.gitsigns = lib.mkIf config.programs.nixvim.enable {
    enable = true;
  };
}
