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
    }
    {
      # gx: open the message body in interactive w3m -- real vim-style
      # cursor navigation (hjkl, Tab/Shift-Tab between links, Enter to
      # follow, B back, q to return to neomutt). Replaces the old
      # urlscan-based link picker.
      map = [
        "index"
        "pager"
      ];
      key = "gx";
      action = "<pipe-message>urlscan<enter>";
    }
    {
      # Ctrl-B in the pager: same interactive w3m view as gx, kept as
      # a second binding since Ctrl-B is a common muscle-memory key
      # for "open this in a browser-like view".
      map = [ "pager" ];
      key = "\\Cb";
      action = "<enter-command>set my_pipe_decode=$pipe_decode pipe_decode=yes<enter><pipe-message>${lib.getExe' config.web.w3m.package "w3m"} -T text/html<enter><enter-command>set pipe_decode=$my_pipe_decode<enter>";
    }
    {
      # Ctrl-B on a specific attachment (not just the top-level
      # message): pipe-entry sends the selected attachment instead.
      map = [ "attach" ];
      key = "\\Cb";
      action = "<pipe-entry>${lib.getExe' config.web.w3m.package "w3m"} -cols 100 -T text/html<enter>";
    }
    {
      # gF: clear the current limit/filter and show every message again,
      # the counterpart to gf (interactive limit prompt) in binds.nix
      map = [ "index" ];
      key = "gF";
      action = "<limit>all<enter>";
    }
    {
      # ZZ: save and quit, vim-style (sync mailbox, then quit)
      map = [ "index" ];
      key = "ZZ";
      action = "<sync-mailbox><quit>";
    }
    {
      # ZQ: quit without saving, vim-style counterpart to ZZ
      map = [ "index" ];
      key = "ZQ";
      action = "<exit>";
    }
  ];
}
