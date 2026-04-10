{ config, lib, ... }:

# Notify - Notification plugin (nvim-notify) - currently disabled
{
  config.programs.nixvim.plugins.notify = lib.mkIf config.tools.nixvim.enable {
    enable = false;
  };
}
