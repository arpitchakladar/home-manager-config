# neomutt - Terminal email client
{ config, lib, ... }:
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
      package = config.communication.neomutt.package;
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = true;
      unmailboxes = true;
      checkStatsInterval = 20;
      extraConfig = builtins.readFile ./.neomuttrc;
    };
  };
}
