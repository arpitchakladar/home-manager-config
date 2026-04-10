{ config, lib, ... }:

# Comment - Comment toggling plugin (comment.nvim)
{
  config.programs.nixvim.plugins.comment = lib.mkIf config.tools.nixvim.enable {
    enable = true;
  };
}
