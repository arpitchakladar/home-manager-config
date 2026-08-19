{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.web.chromium;

  extLib = import ./lib.nix {
    inherit lib pkgs config;
  };

  mkExtension = path: import path { inherit lib pkgs extLib; };

  extensionSubmodule = lib.types.submodule {
    options = {
      pname = lib.mkOption {
        type = lib.types.str;
        description = "Package name of the extension.";
      };
      version = lib.mkOption {
        type = lib.types.str;
        description = "Resolved/pinned version of the extension.";
      };
      id = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Chrome extension ID, derived from the pinned key. Null if the extension isn't key-pinned.";
      };
      drv = lib.mkOption {
        type = lib.types.package;
        description = "Unpacked extension derivation.";
      };
    };
  };
in
{
  imports = [
    ./assertions.nix
  ];

  options.web.chromium.extensions = lib.mkOption {
    type = lib.types.attrsOf extensionSubmodule;
    internal = true;
    default = { };
    description = ''
      Resolved chromium extension derivations, keyed by name. Computed
      internally from ./extensions/*.nix — not user-settable. Read from
      other modules via e.g. `config.web.chromium.extensions.browserpass.id`.
    '';
  };

  # Readonly options get their actual value assigned here in this module
  config.web.chromium.extensions = {
    aria2Explorer = mkExtension ./aria2-explorer;
    browserpass = mkExtension ./browserpass;
    darkreader = mkExtension ./darkreader;
    searxngHome = mkExtension ./searxng-home;
    ublockOrigin = mkExtension ./ublock-origin;
    vimium = mkExtension ./vimium;
  };
}
