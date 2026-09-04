{
  config,
  lib,
  ...
}:
{
  imports = [
    ./bar/bar.nix
  ];

  options.desktop.eww = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.eww.package;
      description = "The eww package to use.";
    };
  };

  config = {
    programs.eww = {
      enable = true;
      systemd = {
        enable = true;
        # Nothing ever activates this, so home-manager's eww.service unit
        # exists but is never auto-started by the session. Rely on eww-bar.service
        # manually starts eww service.
        target = "eww-daemon-manual.target";
      };
      scssConfig =
        let
          baseSize = config.fonts.size;
        in
        builtins.readFile (
          config.scheme {
            template =
              builtins.replaceStrings
                [
                  "@@font-family@@"
                  "@@font-size@@"
                  "@@font-size-icon@@"
                  "@@font-size-label@@"
                  "@@font-size-small@@"
                  "@@font-size-idx@@"
                ]
                [
                  config.fonts.normal
                  (toString baseSize)
                  (toString config.fonts.iconSize)
                  (toString config.fonts.labelSize)
                  (toString config.fonts.smallSize)
                  (toString config.fonts.idxSize)
                ]
                (builtins.readFile ./eww.mustache.scss);
          }
        );
    };

    systemd.user.services.eww-bar = {
      Unit = {
        Description = "Open Eww Bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe config.desktop.eww.package} open bar";
        ExecReload = "${lib.getExe config.desktop.eww.package} reload && ${lib.getExe config.desktop.eww.package} open bar";
        ExecStop = "${lib.getExe config.desktop.eww.package} kill";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
