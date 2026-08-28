# Email suite entry point
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkScriptModule;
  neomuttSync = mkScriptModule {
    scope = [
      "communication"
      "neomutt"
    ];
    name = "neomutt-sync";
    path = ./neomutt-sync.sh;
    description = "Neomutt-sync - Interactive mail sync with dialog progress bar";
    deps = [
      pkgs.bash
      pkgs.dialog
      pkgs.coreutils
      pkgs.gawk
      pkgs.gnused
      pkgs.util-linux
      config.programs.mbsync.package
      config.programs.notmuch.package
    ];
    inherit config;
  };
in
{
  imports = [
    ./account
    ./mail
    ./assertions.nix
    ./keybindings.nix
    ./macros.nix
    ./neomutt.nix
  ];

  options.communication.neomutt = {
    enable = lib.mkEnableOption "Email suite (neomutt + mbsync + notmuch)";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.neomutt.package;
      description = "The neomutt package to use, wrapped with urlscan in PATH.";
    };
  }
  // neomuttSync.options.communication.neomutt;

  config = lib.mkMerge [
    (lib.mkIf config.communication.neomutt.enable {
      accounts.email.maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
      home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;
    })
    neomuttSync.config
    {
      assertions = [
        {
          assertion =
            !config.communication.neomutt.neomutt-sync.enable || config.communication.neomutt.enable;
          message = "communication.neomutt.neomutt-sync is enabled but requires `communication.neomutt.enable`.";
        }
      ];
    }
  ];
}
