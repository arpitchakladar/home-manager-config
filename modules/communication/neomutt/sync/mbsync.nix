# Mbsync - Mailbox synchronization (isync/mbsync)
{ config, lib, ... }:
{
  config = lib.mkIf config.communication.neomutt.enable {
    programs.mbsync.enable = true;
  };
}
