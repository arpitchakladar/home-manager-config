{
  config,
  lib,
  pkgs,
  ...
}:

# Polybar - Status bar configuration (i3 integration, modules)
{
  config = lib.mkIf config.desktop.enable {
    services.polybar.enable = true;
    services.polybar.package = (
      pkgs.polybar.override {
        pulseSupport = true;
        i3Support = true;
      }
    );
    services.polybar.script = "${config.services.polybar.package}/bin/polybar main &";
    services.polybar.config = lib.mkMerge [
      (import ./bar { inherit config; })
      (import ./module { inherit config lib pkgs; })
      {
        settings = {
          screenchange-reload = true;
        };
      }
    ];
  };
}
