{
  config,
  lib,
  name,
  ...
}:
let

  mbsyncNamesFromName = (import ../lib.nix { inherit lib; }).mbsyncNamesFromName;
in
{
  config = lib.mkIf config.enable {
    neomutt.extraConfig =
      let
        mbsyncNames = mbsyncNamesFromName name;
      in
      builtins.replaceStrings
        [ "@@QUICK_CHANNEL@@" "@@FULL_CHANNEL@@" ]
        [
          mbsyncNames.channels.quick
          mbsyncNames.channels.full
        ]
        (builtins.readFile ./.neomuttrc);
  };
}
