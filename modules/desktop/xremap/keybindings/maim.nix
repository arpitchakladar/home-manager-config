{ pkgs }:

{

  "super-p" = {
    launch = [
      "sh"
      "-c"
      "${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png"
    ];
  };
  "super-shift-p" = {
    launch = [
      "sh"
      "-c"
      "mkdir -p ~/Pictures/Screenshots && ${pkgs.maim}/bin/maim -s ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
    ];
  };
}
