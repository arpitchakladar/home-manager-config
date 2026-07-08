{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.programs.aerc.enable {
    programs.aerc = {
      extraConfig = {
        general = {
          unsafe-accounts-conf = false;
          default-save-path = "${config.home.homeDirectory}/Downloads";
          use-terminal-pinentry = false;
        };

        ui = {
          index-columns = "flags:4,name<32%,subject,date>=";
          column-name = "{{with index .From 0}}{{.Address}}{{if .Name}} ({{.Name}}){{end}}{{end}}";
          timestamp-format = "2006-01-02 15:04";
          this-day-time-format = "15:04";
          this-week-time-format = "Mon 15:04";
          sidebar-width = 24;
        };

        viewer = {
          pager = lib.getExe config.programs.less.package;
        };

        filters = ''
          text/plain = wrap -w 100 | colorize
          text/html = ! html
          text/* = ${lib.getExe config.programs.bat.package} -fP --file-name="''${AERC_FILENAME:-message.txt}" --style=plain
          message/delivery-status = colorize
          .headers = colorize
        '';

        hooks = {
          mail-added = "aerc-sync-mail \"$AERC_ACCOUNT\"";
          mail-deleted = "aerc-sync-mail \"$AERC_ACCOUNT\"";
          flag-changed = "aerc-sync-mail \"$AERC_ACCOUNT\"";
        };
      };
    };

    home.file.".config/aerc/notmuch-query-map".text = ''
      Inbox=tag:inbox and not tag:deleted
      Unread=tag:unread and not tag:deleted
      Flagged=tag:flagged and not tag:deleted
      Sent=folder:sent or folder:Sent or folder:"[Gmail]/Sent Mail"
      Archive=not tag:inbox and not tag:deleted
      All=*
    '';
  };
}
