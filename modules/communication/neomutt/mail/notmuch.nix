# Mail indexer for fast email search
{ config, lib, ... }:
let
  cfg = config.communication.neomutt;
in
{
  config = lib.mkIf cfg.enable {
    programs.notmuch.enable = true;
  };
}
