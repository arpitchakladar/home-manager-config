{ config, lib, ... }:

{
  config.programs.neomutt.binds = lib.mkIf config.communication.neomutt.enable [
    {
      map = [
        "index"
        "pager"
      ];
      key = "O";
      action = "<enter-command>set my_wait_key=$wait_key wait_key=no<enter><sync-mailbox><shell-escape>${lib.getExe config.scripts.neomutt-sync.package}<enter><sync-mailbox><enter-command>set wait_key=$my_wait_key<enter>";
    }
    {
      # gx: extract links from the current message and open one, vim-netrw style
      map = [
        "index"
        "pager"
      ];
      key = "gx";
      action = "<pipe-message>urlscan<Enter>";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "gl";
      action = "<shell-escape>less ~/.config/neomutt/flag_legend.txt<enter>";
    }
    {
      # ZZ: save and quit, vim-style (sync mailbox, then quit)
      map = [ "index" ];
      key = "ZZ";
      action = "<sync-mailbox><quit>";
    }
  ];
}
