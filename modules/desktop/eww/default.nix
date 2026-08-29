{
  config,
  lib,
  ...
}:
{
  imports = [
    ./bar.nix
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
      systemd.enable = true;
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
                  (toString (baseSize + 6))
                  (toString (baseSize - 2))
                  (toString (baseSize - 6))
                  (toString (baseSize - 4))
                ]
                (builtins.readFile ./eww.mustache.scss);
          }
        );
    };

    systemd.user.services.eww-bar = {
      Unit = {
        Description = "Open Eww Bar";
        After = [ "eww.service" ];
        Requires = [ "eww.service" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe config.desktop.eww.package} open bar";
        ExecStop = "${lib.getExe config.desktop.eww.package} close bar";
      };
      Install = {
        WantedBy = [ config.programs.eww.systemd.target ];
      };
    };
  };
}
