# some basic common utility functions for neomutt
{ lib, ... }:
{
  mbsyncNamesFromName =
    name:
    let
      channelNameBase = lib.replaceStrings [ "@" "." ] [ "-" "_" ] name;
    in
    {
      base = channelNameBase;
      channels = {
        full = "${channelNameBase}-full";
        quick = "${channelNameBase}-quick";
      };
      servers = {
        remote = "${channelNameBase}-remote";
        local = "${channelNameBase}-local";
      };
    };
}
