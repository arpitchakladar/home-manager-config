# Macros - neomutt macros for sync, URL extraction, flag legend, and quit
{ config, lib, ... }:
{
  config.programs.neomutt.macros = lib.mkIf config.communication.neomutt.enable [
    {
      # sync the mailbox and run the external sync script, silencing the
      # "press any key" prompt around it. Vim mnemonic: g-prefixed, "go sync".
      map = [
        "index"
        "pager"
      ];
      key = "gs";
      action = "<enter-command>set my_wait_key=$wait_key wait_key=no<enter><sync-mailbox><shell-escape>${lib.getExe config.scripts.neomutt-sync.package}<enter><sync-mailbox><enter-command>set wait_key=$my_wait_key<enter>";
    }
    {
      # extract every URL from the message via urlscan into a picker menu,
      # then follow the selected one. Vim mnemonic: gx, same as vim-plugins
      # that open the link/file under the cursor.
      map = [
        "index"
        "pager"
      ];
      key = "gx";
      action = "<pipe-message>urlscan<enter>";
    }
    {
      # open the message body in interactive chawan -- real vim-style
      # cursor navigation (hjkl, Tab/Shift-Tab between links, Enter to
      # follow, B back, q to return to neomutt). Replaces the old
      # urlscan-based link picker.
      # Kept on Ctrl-B since that's common muscle-memory for "open this in
      # a browser-like view" - previous-page is intentionally NOT bound to
      # Ctrl-B in the pager (see binds.nix) so this doesn't get shadowed.
      map = [ "pager" ];
      key = "\\Cb";
      action = "<enter-command>set my_pipe_decode=$pipe_decode pipe_decode=yes<enter><pipe-message>${lib.getExe config.web.chawan.package} -o \"title='neomutt'\"<enter><enter-command>set pipe_decode=$my_pipe_decode<enter>";
    }
    {
      # on a specific attachment (not just the top-level
      # message): pipe-entry sends the selected attachment instead.
      # Same gx mnemonic as the index/pager macro above.
      map = [ "attach" ];
      key = "gx";
      action = "<pipe-entry>${lib.getExe config.web.chawan.package} -o \"title='neomutt'\" <enter>";
    }
    {
      # clear the current limit/filter and show every message again,
      # the counterpart to gf (interactive limit prompt) in binds.nix
      map = [ "index" ];
      key = "gF";
      action = "<limit>all<enter>";
    }
    {
      # save and quit, vim-style (sync mailbox, then quit) - same ZZ
      # you'd type in vim to write and exit
      map = [ "index" ];
      key = "ZZ";
      action = "<sync-mailbox><quit>";
    }
    {
      # quit without saving, vim-style counterpart to ZZ - same ZQ
      # you'd type in vim to discard and exit
      map = [ "index" ];
      key = "ZQ";
      action = "<exit>";
    }
  ];
}
