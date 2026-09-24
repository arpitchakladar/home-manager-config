# Email suite entry point
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.communication.neomutt;

  mbsyncNamesFromName = (import ./lib.nix { inherit lib; }).mbsyncNamesFromName;

  fullSyncChannels = lib.mapAttrsToList (name: account: (mbsyncNamesFromName name).channels.full) (
    lib.filterAttrs (name: account: account.enable) cfg.accounts
  );

  neomuttSyncScript = pkgs.writeShellApplication {
    name = "neomutt-sync";
    runtimeInputs = [
      config.terminal.bash.package
      pkgs.dialog
      pkgs.coreutils
      pkgs.gawk
      pkgs.gnused
      pkgs.util-linux
      config.programs.mbsync.package
      config.programs.notmuch.package
    ];
    text = builtins.readFile ./neomutt-sync.sh;
  };

  neomuttSyncDaemon = pkgs.writeShellApplication {
    name = "neomutt-sync-daemon";
    runtimeInputs = [
      config.terminal.bash.package
      pkgs.coreutils
      pkgs.procps
      config.programs.mbsync.package
      config.programs.notmuch.package
    ];
    text = builtins.readFile ./neomutt-sync-daemon.sh;
  };

  neomuttLauncher = pkgs.writeShellApplication {
    name = "neomutt-launcher";
    runtimeInputs = [
      pkgs.systemd
      pkgs.procps
      pkgs.neomutt
      pkgs.urlscan
    ];
    text =
      builtins.replaceStrings
        [
          "@@NEOMUTT_BIN@@"
        ]
        [
          (lib.getExe pkgs.neomutt)
        ]
        (builtins.readFile ./neomutt-launcher.sh);
  };

  neomuttSyncCompletion =
    pkgs.runCommand "neomutt-sync-completion"
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
      }
      ''
        mkdir -p $out/share/zsh/site-functions
        installShellCompletion --zsh --name _neomutt-sync ${pkgs.writeText "neomutt-sync.zsh" (builtins.readFile ./neomutt-sync.zsh)}
      '';

  neomuttSync = pkgs.symlinkJoin {
    name = "nix-update";
    paths = [
      neomuttSyncScript
      neomuttSyncCompletion
    ];
    meta = neomuttSyncScript.meta;
  };
in
{
  imports = [
    ./account
    ./mail
    ./assertions.nix
    ./keybindings.nix
    ./macros.nix
  ];

  options.communication.neomutt = {
    enable = lib.mkEnableOption "Email suite (neomutt + mbsync + notmuch)";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.neomutt.package;
      description = "The neomutt package to use, wrapped with urlscan in PATH.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      accounts.email.maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
      home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;

      xdg.configFile."neomutt/mailcap".text =
        builtins.replaceStrings [ "@@HTML_VIEWER@@" ] [ (lib.getExe config.web.chawan.package) ]
          (builtins.readFile ./mailcap);
      home.file.".local/share/icons/hicolor/scalable/apps/neomutt.svg".source =
        "${config.programs.neomutt.package}/share/neomutt/logo/neomutt.svg";

      programs.neomutt = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "neomutt-wrapped";
          paths = [
            neomuttLauncher
            pkgs.neomutt
            neomuttSync
          ];
          meta.mainProgram = "neomutt-launcher";
        };
        sidebar.enable = true;
        sort = "reverse-threads";
        vimKeys = false;
        unmailboxes = true;
        checkStatsInterval = 20;
        extraConfig = builtins.replaceStrings [ "@@PAGER@@" ] [ (lib.getExe config.web.chawan.package) ] (
          builtins.readFile ./.neomuttrc
        );
      };

      systemd.user.services.neomutt-sync = {
        Unit = {
          Description = "Full mail sync while neomutt is running";
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe neomuttSyncDaemon} ${lib.concatStringsSep " " fullSyncChannels}";
        };
      };
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."neomutt" = {
        name = "NeoMutt";
        exec = "${lib.getExe config.terminal.kitty.package} --class neomutt -e ${lib.getExe config.programs.neomutt.package}";
        icon = "neomutt";
        categories = [
          "Network"
          "Email"
        ];
        comment = "Terminal email client";
        terminal = false;
        type = "Application";
      };
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/mailto" = "neomutt.desktop";
      };
    })
  ];
}
