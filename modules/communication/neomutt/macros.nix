# neomutt macros for sync, URL extraction, flag legend, and quit
{ config, lib, ... }:
{
  config.programs.neomutt.macros = lib.mkIf config.communication.neomutt.enable [
    {
      # Sync the mailbox and run the external sync script
      map = [
        "index"
        "pager"
      ];
      key = "gs";
      action = "<enter-command>set my_wait_key=$wait_key wait_key=no<enter><sync-mailbox><shell-escape>${lib.getExe config.communication.neomutt.neomutt-sync.package}<enter><sync-mailbox><enter-command>set wait_key=$my_wait_key<enter>";
    }
    {
      # Extract every URL from the message via urlscan into a picker menu
      map = [
        "index"
        "pager"
      ];
      key = "gx";
      action = "<pipe-message>urlscan<enter>";
    }
    {
      # Pipe the selected attachment instead of the whole message
      map = [ "attach" ];
      key = "gx";
      action = "<pipe-entry>${lib.getExe config.web.chawan.package} -o \"title='neomutt'\" <enter>";
    }
    {
      # Clear the current limit and show every message again
      map = [ "index" ];
      key = "gF";
      action = "<limit>all<enter>";
    }
    {
      # Save the mailbox and quit
      map = [ "index" ];
      key = "ZZ";
      action = "<sync-mailbox><quit>";
    }
  ];
}
