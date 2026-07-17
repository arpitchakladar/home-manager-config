# Macros - neomutt macros for sync, URL extraction, flag legend, and quit
{ config, lib, ... }:
{
  config.programs.neomutt.macros = lib.mkIf config.communication.neomutt.enable [
    {
      map = [
        "index"
        "pager"
      ];
      key = "O";
      action = "<enter-command>set my_wait_key=$wait_key wait_key=no<enter><sync-mailbox><shell-escape>${lib.getExe config.scripts.neomutt-sync.package}<enter><sync-mailbox><enter-command>set wait_key=$my_wait_key<enter>";
      description = "sync mailbox (run neomutt-sync)";
    }
    {
      # gx: extract links from the current message and open one, vim-netrw style
      map = [
        "index"
        "pager"
      ];
      key = "gx";
      action = "<pipe-message>urlscan<Enter>";
      description = "extract links from message (netrw-style)";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "gl";
      action = "<shell-escape>less ~/.config/neomutt/flag_legend.txt<enter>";
      description = "show flag legend";
    }
    {
      # gF: clear the current limit/filter and show every message again,
      # the counterpart to gf (interactive limit prompt) in binds.nix
      map = [ "index" ];
      key = "gF";
      action = "<limit>~A<enter>";
      description = "clear limit/filter, show all messages";
    }
    {
      # ZZ: save and quit, vim-style (sync mailbox, then quit)
      map = [ "index" ];
      key = "ZZ";
      action = "<sync-mailbox><quit>";
      description = "save changes and quit";
    }
    {
      # ZQ: quit without saving, vim-style counterpart to ZZ
      map = [ "index" ];
      key = "ZQ";
      action = "<exit>";
      description = "quit without saving";
    }
  ];
}
