# Mailbox synchronization
{ config, lib, ... }:
{
  config = lib.mkIf config.communication.neomutt.enable {
    programs.mbsync.enable = true;
  };
}
