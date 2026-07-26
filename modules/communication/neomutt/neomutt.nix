# neomutt - Terminal email client
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.communication.neomutt.enable {
    xdg.desktopEntries."neomutt" = {
      name = "NeoMutt";
      exec = "${lib.getExe config.terminal.kitty.package} --class neomutt -e ${lib.getExe config.programs.neomutt.package}";
      icon = "kitty";
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
    home.packages = with pkgs; [
      urlscan
    ];
    xdg.configFile."neomutt/mailcap".text = ''
      text/html; ${lib.getExe' config.web.w3m.package "w3m"} -dump -cols 100 -T text/html '%s'; copiousoutput; nametemplate=%s.html
      image/*; xdg-open '%s' &
      application/pdf; xdg-open '%s'; nametemplate=%s.pdf
      video/*; xdg-open '%s' &
      audio/*; xdg-open '%s' &
      application/*; xdg-open '%s' &
    '';
    xdg.configFile."neomutt/flag_legend.txt".text = ''
      NeoMutt Index Flags
      ===================
      Message state ($flag_chars) -- unchanged defaults
        N   New       - unread, arrived since you last checked
        O   Old       - unread, but seen in a previous session
        D   Deleted   - marked for deletion (pending expunge)
        d   Att-del   - has attachments marked for deletion
        !   Flagged   - important (toggle with F)
        *   Tagged    - selected for a bulk operation (toggle with t)
        r   Replied   - you've replied to this message
        (blank)       - read, nothing else notable
      Cryptography ($crypt_chars)
           Verified   - signed, and the signature checks out
           Encrypted  - PGP/SMIME encrypted
           Signed     - PGP/SMIME signed (unverified)
           PGP key    - message contains a PGP public key
        (blank)         - no cryptography info
      Addressing ($to_chars)
           To you only      - sent to you and only you
           To (with others) - you're in the To: list, among others
           Cc only          - you're only in the Cc: list
           From you         - sent by you
           Mailing list     - sent to a list you're subscribed to
        (blank)              - not in To/Cc (e.g. Bcc, unlisted)
      Press q to close.
    '';
    programs.neomutt = {
      enable = true;
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = true;
      unmailboxes = true;
      checkStatsInterval = 20;
      extraConfig = builtins.readFile ./.neomuttrc;
    };
  };
}
