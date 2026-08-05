# Mail indexer for fast email search
{ config, lib, ... }:
{
  config = lib.mkIf config.communication.neomutt.enable {
    programs.notmuch.enable = true;
  };
}
