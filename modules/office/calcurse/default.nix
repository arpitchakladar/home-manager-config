# Text-based calendar and scheduling application
{
  config,
  lib,
  pkgs,
  ...
}:
let
  calcurseSync = pkgs.writeShellScriptBin "calcurse-sync" (builtins.readFile ./calcurse-sync.sh);

  calcursePackage = pkgs.symlinkJoin {
    name = "calcurse-wrapped";
    paths = [
      pkgs.bash
      pkgs.calcurse
    ]
    ++ lib.optionals config.development.nixvim.enable [ config.development.nixvim.package ]
    ++ lib.optionals config.office.calcurse.sync.enable [ calcurseSync ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      ${lib.optionalString config.development.nixvim.enable ''
        wrapProgram $out/bin/calcurse --set PAGER "nvim"
      ''}
      ${lib.optionalString config.office.calcurse.sync.enable ''
        wrapProgram $out/bin/calcurse-sync \
          --prefix PATH : ${
            lib.makeBinPath [
              config.development.git.package
              pkgs.coreutils
              pkgs.gnused
            ]
          } \
          ${lib.optionalString (config.office.calcurse.sync.remote != null) ''
            --set CALCURSE_SYNC_REMOTE ${lib.escapeShellArg config.office.calcurse.sync.remote}
          ''}
      ''}
    '';
    meta = {
      mainProgram = "calcurse";
    };
  };
in
{
  options.office.calcurse = {
    enable = lib.mkEnableOption "Enables calcurse.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = calcursePackage;
      description = "The calcurse package to use.";
    };
    sync = {
      enable = lib.mkEnableOption "Enables git-backed syncing of the calcurse data directory (builds calcurse-sync, installs the sync hooks, and runs an initial 'calcurse-sync init' on activation).";
      remote = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Git remote URL for the calcurse data directory. When set, calcurse-sync uses it automatically on first init instead of prompting.";
      };
    };
  };

  config = lib.mkIf config.office.calcurse.enable (
    lib.mkMerge [
      {
        home.packages = [ config.office.calcurse.package ];
        xdg.configFile."calcurse/conf" = {
          source = ./conf;
          force = true;
        };
        xdg.configFile."calcurse/keys" = {
          source = ./keys;
          force = true;
        };
      }
      (lib.mkIf config.office.calcurse.sync.enable {
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
            };
          }
        ];

        home.activation.calcurseSyncInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ${config.office.calcurse.package}/bin/calcurse-sync init || true
        '';
      })
    ]
  );
}
