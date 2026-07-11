# neomutt - Terminal email client
{
  config,
  lib,
  pkgs,
  ...
}:
let
  neomuttDesktopItem = pkgs.makeDesktopItem {
    name = "neomutt";
    desktopName = "NeoMutt";
    exec = "${lib.getExe config.programs.kitty.package} -e ${lib.getExe config.programs.neomutt.package}";
    icon = "kitty";
    categories = [
      "Network"
      "Email"
    ];
    comment = "Terminal email client";
    terminal = false;
    type = "Application";
  };
in
{
  imports = [
    ./assertions.nix
    ./theme.nix
  ];
  config = lib.mkIf config.programs.neomutt.enable {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = "neomutt.desktop";
    };

    home.packages = [
      pkgs.urlscan
      pkgs.w3m
      neomuttDesktopItem
    ];

    xdg.configFile."neomutt/mailcap".text = ''
      text/html; w3m -dump -T text/html '%s'; copiousoutput; nametemplate=%s.html
      text/html; $BROWSER '%s'; nametemplate=%s.html
      image/*; xdg-open '%s' &
      application/pdf; xdg-open '%s'; nametemplate=%s.pdf
      video/*; xdg-open '%s' &
      audio/*; xdg-open '%s' &
      application/*; xdg-open '%s' &
    '';

    xdg.configFile."neomutt/flag_legend.txt".text = ''
      NeoMutt Index Flags
      ===================

      Message state ($flag_chars)
        N   New       - unread, arrived since you last checked
        O   Old       - unread, but seen in a previous session
        D   Deleted   - marked for deletion (pending expunge)
        d   Att-del   - has attachments marked for deletion
        !   Flagged   - important (toggle with F)
        *   Tagged    - selected for a bulk operation (toggle with t)
        r   Replied   - you've replied to this message
        S   Signed    - PGP/SMIME signed
        P   Encrypted - PGP/SMIME encrypted
        s   Cert      - contains a S/MIME certificate/key
        K   PGP key   - contains a PGP public key
        (blank)       - read, nothing else notable

      Addressing ($to_chars)
        +   To you only     - sent to you and only you
        T   To (with others) - you're in the To: list, among others
        C   Cc only          - you're only in the Cc: list
        F   From you         - sent by you
        L   Mailing list     - sent to a list you're subscribed to
        (blank)              - not in To/Cc (e.g. Bcc, unlisted)

      Press q to close.
    '';

    programs.neomutt = {
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = true;
      unmailboxes = true;
      checkStatsInterval = 20;

      extraConfig = ''
        set menu_scroll = yes

        # cancel any prompt/command-line entry with Esc, vim-style
        set abort_key = "<Esc>"

        # attachments: use our mailcap for dedicated openers,
        # and auto-render html/images inline where sensible
        set mailcap_path = "~/.config/neomutt/mailcap"
        auto_view text/html image/png image/jpeg image/gif application/pdf
      '';

      binds = [
        # --- sidebar navigation (vim: k=up, j=down) ---
        {
          map = [
            "index"
            "pager"
          ];
          key = "\\CK";
          action = "sidebar-prev";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "\\CJ";
          action = "sidebar-next";
        }
        {
          # select the highlighted mailbox directly, no Ctrl+O needed
          map = [
            "index"
            "pager"
          ];
          key = "o";
          action = "sidebar-open";
        }

        # --- open / go deeper (vim: l = right/forward) ---
        {
          map = [ "index" ];
          key = "<Return>";
          action = "display-message";
        }
        {
          map = [ "index" ];
          key = "l";
          action = "display-message";
        }
        {
          map = [ "browser" ];
          key = "<Return>";
          action = "select-entry";
        }
        {
          map = [ "browser" ];
          key = "l";
          action = "select-entry";
        }
        {
          map = [ "attach" ];
          key = "<Return>";
          action = "view-attach";
        }
        {
          map = [ "attach" ];
          key = "l";
          action = "view-attach";
        }
        {
          map = [
            "alias"
            "query"
          ];
          key = "<Return>";
          action = "select-entry";
        }

        # --- back / exit (vim: h = left/back) ---
        {
          map = [ "pager" ];
          key = "h";
          action = "exit";
        }
        {
          map = [ "browser" ];
          key = "h";
          action = "exit";
        }
        {
          map = [ "attach" ];
          key = "h";
          action = "exit";
        }
        {
          map = [ "index" ];
          key = "h";
          action = "collapse-thread";
        }

        # --- pager line scrolling (vim: j/k move by line) ---
        {
          map = [ "pager" ];
          key = "j";
          action = "next-line";
        }
        {
          map = [ "pager" ];
          key = "k";
          action = "previous-line";
        }
        {
          # kept from before: jump straight to the next unread message,
          # extends the h/l "back/forward" metaphor already in use
          map = [ "pager" ];
          key = "l";
          action = "next-unread";
        }

        # --- top/bottom of buffer (vim: gg/G -- NOT 0/$, which mean
        #     start/end of *line* in vim and would be a false friend here) ---
        {
          map = [ "index" ];
          key = "gg";
          action = "first-entry";
        }
        {
          map = [ "index" ];
          key = "G";
          action = "last-entry";
        }
        {
          map = [ "pager" ];
          key = "gg";
          action = "top";
        }
        {
          map = [ "pager" ];
          key = "G";
          action = "bottom";
        }
        {
          map = [ "browser" ];
          key = "gg";
          action = "first-entry";
        }
        {
          map = [ "browser" ];
          key = "G";
          action = "last-entry";
        }

        # --- page scrolling (vim: Ctrl-f/b full page, Ctrl-d/u half page) ---
        {
          map = [ "pager" ];
          key = "\\Cf";
          action = "next-page";
        }
        {
          map = [ "pager" ];
          key = "\\Cb";
          action = "previous-page";
        }
        {
          map = [ "pager" ];
          key = "\\Cd";
          action = "half-down";
        }
        {
          map = [ "pager" ];
          key = "\\Cu";
          action = "half-up";
        }
        {
          # index has no half-page concept, so Ctrl-d/u fall back to
          # the same full-page scroll as Ctrl-f/b
          map = [ "index" ];
          key = "\\Cf";
          action = "next-page";
        }
        {
          map = [ "index" ];
          key = "\\Cb";
          action = "previous-page";
        }
        {
          map = [ "index" ];
          key = "\\Cd";
          action = "half-down";
        }
        {
          map = [ "index" ];
          key = "\\Cu";
          action = "half-up";
        }

        # --- search (vim: / forward, ? backward, n/N repeat) ---
        {
          map = [
            "index"
            "pager"
          ];
          key = "/";
          action = "search";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "?";
          action = "search-reverse";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "n";
          action = "search-next";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "N";
          action = "search-opposite";
        }

        {
          map = [
            "index"
            "pager"
          ];
          key = "u";
          action = "undelete-message";
        }

        # --- copy (vim: yy yank -- non-destructive, unlike save-message
        #     which moves/deletes the original) ---
        {
          map = [ "index" ];
          key = "y";
          action = "noop";
        }
        {
          map = [ "index" ];
          key = "yy";
          action = "copy-message";
        }

        # --- tagging (vim: v/V visual select single/whole block) ---
        # NOTE: this overrides neomutt's default "v" (view-attachments).
        # Attachments are still reachable from the pager/index via the
        # mailcap auto-view or the attach menu, but if you want plain
        # "v" back for view-attachments, just delete these two binds.
        {
          map = [ "index" ];
          key = "v";
          action = "tag-entry";
        }
        {
          map = [ "index" ];
          key = "V";
          action = "tag-thread";
        }

        # --- mailbox switching (vim: gt = next tab) ---
        {
          map = [ "index" ];
          key = "gt";
          action = "next-unread-mailbox";
        }

        # --- help message to show functions and keybindings ---
        {
          map = [
            "index"
            "pager"
            "browser"
            "attach"
          ];
          key = "g?";
          action = "help";
        }
      ];

      macros = [
        {
          map = [
            "index"
            "pager"
          ];
          key = "O";
          action = "<sync-mailbox><shell-escape>mbsync -a<enter><sync-mailbox>";
        }
        {
          # gx: extract links from the current message and open one, vim-netrw style
          map = [
            "index"
            "pager"
          ];
          key = "gx";
          action = "<pipe-message>urlscan<Enter>";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "gl";
          action = "<shell-escape>less ~/.config/neomutt/flag_legend.txt<enter>";
        }
        {
          # ZZ: save and quit, vim-style (sync mailbox, then quit)
          map = [ "index" ];
          key = "ZZ";
          action = "<sync-mailbox><quit>";
        }
      ];
    };
  };
}
