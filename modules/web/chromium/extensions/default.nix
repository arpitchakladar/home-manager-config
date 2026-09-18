{
  lib,
  pkgs,
  config,
  ...
}:
let
  extLib = import ./lib.nix {
    inherit lib pkgs config;
  };

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

  config.web.chromium.extensions = {
    aria2Explorer = import ./aria2-explorer { inherit lib pkgs extLib; };
    browserpass = import ./browserpass { inherit lib pkgs extLib; };
    darkreader = import ./darkreader { inherit lib pkgs extLib; };
    searxngHome = import ./searxng-home { inherit lib pkgs extLib; };
    ublockOrigin = import ./ublock-origin { inherit lib pkgs extLib; };
    vimium = import ./vimium { inherit lib pkgs extLib; };
  };
}
