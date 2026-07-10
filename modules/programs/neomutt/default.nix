# neomutt - Terminal email client
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./assertions.nix
    ./theme.nix
  ];
  config = lib.mkIf config.programs.neomutt.enable {
    home.packages = [
      pkgs.urlscan
      pkgs.w3m
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
        # cancel any prompt/command-line entry with Esc, vim-style
        set abort_key = "<Esc>"

        # attachments: use our mailcap for dedicated openers,
        # and auto-render html/images inline where sensible
        set mailcap_path = "~/.config/neomutt/mailcap"
        auto_view text/html image/png image/jpeg image/gif application/pdf
      '';

      binds = [
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

        {
          map = [ "index" ];
          key = "<Return>";
          action = "display-message";
        }
        {
          map = [ "browser" ];
          key = "<Return>";
          action = "select-entry";
        }
        {
          map = [ "attach" ];
          key = "<Return>";
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
        {
          map = [ "pager" ];
          key = "<Return>";
          action = "next-page";
        }

        {
          map = [ "index" ];
          key = "l";
          action = "display-message";
        }
        {
          map = [ "pager" ];
          key = "h";
          action = "exit";
        }
        {
          map = [ "pager" ];
          key = "l";
          action = "next-unread";
        }
        {
          map = [ "index" ];
          key = "h";
          action = "collapse-thread";
        }

        {
          map = [ "pager" ];
          key = "0";
          action = "top";
        }
        {
          map = [ "pager" ];
          key = "$";
          action = "bottom";
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
      ];
    };
  };
}
