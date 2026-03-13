{ pkgs }:

{

  "XF86AudioPlay" = {
    launch = [
      "sh"
      "-c"
      "${pkgs.playerctl}/bin/playerctl play-pause"
    ];
  };
}
