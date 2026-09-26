# Text-based calendar and scheduling application
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.office.calcurse;

  calcurseSync = pkgs.writeShellScriptBin "calcurse-sync" (builtins.readFile ./calcurse-sync.sh);

  calcurse = pkgs.symlinkJoin {
    name = "calcurse-wrapped";
    paths = [
      config.terminal.bash.package
      pkgs.calcurse
      pkgs.libnotify
    ]
    ++ lib.optionals config.development.nixvim.enable [ config.development.nixvim.package ]
    ++ lib.optionals cfg.sync.enable [ calcurseSync ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      ${lib.optionalString config.development.nixvim.enable ''
        wrapProgram $out/bin/calcurse --set PAGER "nvim"
      ''}
      ${lib.optionalString cfg.sync.enable ''
        wrapProgram $out/bin/calcurse-sync \
          --prefix PATH : ${
            lib.makeBinPath [
              config.development.git.package
              pkgs.coreutils
              pkgs.gnused
            ]
          } \
          ${lib.optionalString (cfg.sync.remote != null) ''
            --set CALCURSE_SYNC_REMOTE ${lib.escapeShellArg cfg.sync.remote}
          ''}
      ''}
    '';
    meta = {
      mainProgram = "calcurse";
    };
  };
in
{
  imports = [ ./assertions.nix ];

  options.office.calcurse = {
    enable = lib.mkEnableOption "Enables calcurse.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = calcurse;
      description = "The calcurse package to use.";
    };
    sync = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enables git-backed syncing of the calcurse data directory (builds calcurse-sync, installs the sync hooks, and runs an initial 'calcurse-sync init' on activation).";
          remote = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Git remote URL for the calcurse data directory. Use an https:// URL if 'credential' is configured. When set, calcurse-sync uses it automatically on first init instead of prompting.";
          };
          credential = lib.mkOption {
            type = lib.types.submodule {
              options = {
                username = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Username for HTTPS git authentication against the calcurse remote.";
                };
                password-gopass-secret = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "gopass entry path holding the password or token used for HTTPS git authentication against the calcurse remote. E.g. 'git/calcurse-sync'.";
                };
              };
            };
            default = { };
            description = "Credentials for HTTPS git authentication.";
          };
        };
      };
      default = { };
      description = "Git-backed syncing configuration.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
      xdg.configFile."calcurse/conf" = {
        text = builtins.replaceStrings [ "@@CALCURSE_ICON@@" ] [ "calendar" ] (builtins.readFile ./conf);
        force = true;
      };
      xdg.configFile."calcurse/keys" = {
        source = ./keys;
        force = true;
      };
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."calcurse" = {
        name = "calcurse";
        exec = "${lib.getExe config.terminal.kitty.package} --class calcurse -e ${lib.getExe cfg.package}";
        icon = "calendar";
        categories = [
          "Office"
          "Calendar"
        ];
        comment = "Text-based calendar and scheduling application";
        terminal = false;
        type = "Application";
      };
    })
    (lib.mkIf cfg.sync.enable {
      xdg.configFile."calcurse/hooks/pre-load" = {
        source = ./hooks/pre-load;
        executable = true;
        force = true;
      };
      xdg.configFile."calcurse/hooks/post-save" = {
        source = ./hooks/post-save;
        executable = true;
        force = true;
      };

      programs.git.includes = lib.mkIf config.development.git.enable [
        {
          condition = "gitdir:${config.xdg.dataHome}/calcurse/";
          contents = {
            user = {
              name = "Calcurse of ${config.home.username}";
              email = "${config.home.username}@calcurse.localhost";
            };
            commit.gpgSign = false;
            tag.gpgSign = false;
          }
          // lib.optionalAttrs (cfg.sync.credential.password-gopass-secret != null) {
            credential.helper = "!f() { echo username=${lib.escapeShellArg cfg.sync.credential.username}; echo password=\"$(${lib.getExe config.security.gopass.package} show -o ${lib.escapeShellArg cfg.sync.credential.password-gopass-secret})\"; }; f";
          };
        }
      ];

      home.activation.calcurseSyncInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe cfg.package} init || true
      '';
    })
  ];
}
