{
  lib,
  pkgs,
  config,
  checkForUpdates ? true,
}:
let
  extLib = import ./lib.nix {
    inherit
      lib
      pkgs
      config
      checkForUpdates
      ;
  };
  mkExtension = path: import path { inherit lib pkgs extLib; };
in
{
  aria2Explorer = mkExtension ./aria2-explorer.nix;
  browserpass = mkExtension ./browserpass.nix;
  darkMode = mkExtension ./dark-mode.nix;
  searxngHome = mkExtension ./searxng-home.nix;
  theme = mkExtension ./theme.nix;
  ublockOrigin = mkExtension ./ublock-origin.nix;
}
