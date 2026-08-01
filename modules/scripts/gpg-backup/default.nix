{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "gpg-backup";
    path = ./script.sh;
    description = "Export/import all GPG keys as a single passphrase-protected file with maximum S2K iteration count\nUsage: gpg-backup export filename.gpg | gpg-backup import filename.gpg";
    deps = [
      pkgs.gnupg
      pkgs.gnutar
      pkgs.coreutils
      pkgs.findutils
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
