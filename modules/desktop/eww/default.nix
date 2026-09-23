# ElKowar's Wacky Widgets — desktop widgets and bar
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.eww;
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
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
        # Nothing auto-starts home-manager's eww.service unit; the eww-bar
        # service below starts the daemon on demand.
        target = "eww-daemon-manual.target";
      };
      scssConfig =
        let
          themedStyleSheet =
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
                (toString config.fonts.size)
                (toString config.fonts.icon-size)
                (toString config.fonts.label-size)
                (toString config.fonts.small-size)
                (toString config.fonts.idx-size)
              ]
              (builtins.readFile ./eww.scss);
        in
        builtins.readFile (base16Colors {
          templateFileOrContent = themedStyleSheet;
        });
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
        ExecStart = "${lib.getExe cfg.package} open bar";
        ExecReload = "${lib.getExe cfg.package} reload && ${lib.getExe cfg.package} open bar";
        ExecStop = "${lib.getExe cfg.package} kill";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
