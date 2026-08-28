# Email suite entry point
{
  config,
  lib,
  pkgs,
  ...
}:
let
  neomuttSyncScript = pkgs.writeShellApplication {
    name = "neomutt-sync";
    runtimeInputs = [
      pkgs.bash
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

  config = lib.mkIf config.communication.neomutt.enable {
    accounts.email.maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
    home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;

    xdg.desktopEntries."neomutt" = {
      name = "NeoMutt";
      exec = "${lib.getExe config.terminal.kitty.package} --class neomutt -e ${lib.getExe config.programs.neomutt.package}";
      icon = "${config.programs.neomutt.package}/share/neomutt/logo/neomutt.svg";
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
    xdg.configFile."neomutt/mailcap".text = ''
      text/html; ${lib.getExe config.web.chawan.package} -o "title='neomutt'" '%s'; nametemplate=%s.html
      image/*; xdg-open '%s' &
      application/pdf; xdg-open '%s'; nametemplate=%s.pdf
      video/*; xdg-open '%s' &
      audio/*; xdg-open '%s' &
      application/*; xdg-open '%s' &
    '';
    programs.neomutt = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "neomutt-wrapped";
        paths = [
          pkgs.neomutt
          neomuttSyncScript
        ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/neomutt \
            --prefix PATH : ${config.home.profileDirectory}/bin:${lib.makeBinPath [ pkgs.urlscan ]}
        '';
        meta.mainProgram = "neomutt";
      };
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = false;
      unmailboxes = true;
      checkStatsInterval = 20;
      extraConfig = ''
        # Read messages in Neovim.  `-` makes Neovim read the message from
        # stdin and -R prevents accidental edits to message content.
        set pager = "${lib.getExe config.development.nixvim.package} -R -n +'setlocal nolist | silent! 1,2g/^$/delete _ | nohlsearch | setlocal nomodified nomodifiable' -"
        # Return directly to the index when Neovim exits and do not prepend
        # NeoMutt’s pager status line to the message passed to Neovim.
        set noprompt_after
        set pager_format = ""
      ''
      + builtins.readFile ./.neomuttrc;
    };
  };
}
