# Notmuch - Mail indexer for fast email search
{ config, lib, ... }:

with lib;

{
  config = mkIf config.communication.neomutt.enable {
    programs.notmuch.enable = true;
  };
}
