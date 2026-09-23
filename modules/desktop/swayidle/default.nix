# swayidle idle management daemon
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.swayidle;
in
{
  options.desktop.swayidle = {
    enable = lib.mkEnableOption "Enables swayidle.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.swayidle;
      description = "The swayidle package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      package = cfg.package;
      systemdTargets = [ "graphical-session.target" ];
      timeouts = [
        {
          timeout = 10 * 60; # 10 mins
          command = "${lib.getExe config.desktop.niri.package} msg action power-off-monitors";
          resumeCommand = "${lib.getExe config.desktop.niri.package} msg action power-on-monitors";
        }
      ];
      events = {
        "before-sleep" = "${lib.getExe config.desktop.niri.package} msg action power-off-monitors";
        "after-resume" = "${lib.getExe config.desktop.niri.package} msg action power-on-monitors";
      };
    };
  };
}
