{
  lib,
  pkgs,
  checkForUpdates ? true,
}:
let
  extLib = import ./lib.nix { inherit lib pkgs checkForUpdates; };
  mkExtension = path: import path { inherit lib pkgs extLib; };
in
{
  ublockOrigin = mkExtension ./ublock-origin.nix;
  darkMode = mkExtension ./dark-mode.nix;
  browserpass = mkExtension ./browserpass.nix;
  aria2Explorer = mkExtension ./aria2-explorer.nix;
}
