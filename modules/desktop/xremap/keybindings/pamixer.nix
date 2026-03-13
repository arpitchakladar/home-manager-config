{ pkgs }:

{

  "XF86AudioLowerVolume" = {
    launch = [
      "sh"
      "-c"
      "${pkgs.pamixer}/bin/pamixer --decrease 5"
    ];
  };
  "XF86AudioRaiseVolume" = {
    launch = [
      "sh"
      "-c"
      "${pkgs.pamixer}/bin/pamixer --increase 5"
    ];
  };
  "XF86AudioMute" = {
    launch = [
      "sh"
      "-c"
      "${pkgs.pamixer}/bin/pamixer --toggle-mute"
    ];
  };
}
