# neomutt macros for sync, URL extraction, flag legend, and quit
{ config, lib, ... }:
let
  cfg = config.communication.neomutt;
in
{
  config.programs.neomutt.macros = lib.mkIf cfg.enable [
    {
      map = [
        "index"
        "pager"
      ];
      key = "gx";
      action = "<pipe-message>urlscan<enter>";
    }
    {
      map = [ "index" ];
      key = "gF";
      action = "<limit>all<enter>";
    }
    {
      map = [ "index" ];
      key = "ZZ";
      action = "<sync-mailbox><quit>";
    }
  ];
}
