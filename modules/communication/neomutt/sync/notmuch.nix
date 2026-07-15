{ config, lib, ... }:

with lib;

{
  config = mkIf config.communication.neomutt.enable {
    programs.notmuch.enable = true;
  };
}
