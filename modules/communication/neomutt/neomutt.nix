# Terminal email client
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
        paths = [ pkgs.neomutt ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/neomutt \
            --prefix PATH : ${lib.makeBinPath [ pkgs.urlscan ]}
        '';
        meta.mainProgram = "neomutt";
      };
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = false;
      unmailboxes = true;
      checkStatsInterval = 20;
      extraConfig = builtins.readFile ./.neomuttrc;
    };
  };
}
