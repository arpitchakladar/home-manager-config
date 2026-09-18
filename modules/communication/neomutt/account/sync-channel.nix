{
  config,
  lib,
  name,
  ...
}@inputs:
let

  mbsyncNamesFromName = (import ../lib.nix { inherit lib; }).mbsyncNamesFromName;
in
{
  config = lib.mkIf config.enable {
    neomutt.extraConfig =
      let
        mbsyncNames = mbsyncNamesFromName name;
      in
      ''
        macro index,pager gs "<enter-command>set my_wait_key=$wait_key wait_key=no<enter><sync-mailbox><shell-escape>neomutt-sync ${mbsyncNames.channels.quick}<enter><sync-mailbox><enter-command>set wait_key=$my_wait_key<enter>"
        macro index,pager gS "<enter-command>set my_wait_key=$wait_key wait_key=no<enter><sync-mailbox><shell-escape>neomutt-sync ${mbsyncNames.channels.full}<enter><sync-mailbox><enter-command>set wait_key=$my_wait_key<enter>"
      '';
  };
}
