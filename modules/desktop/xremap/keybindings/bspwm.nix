{ pkgs }:

{

  "super-q" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-c"
    ];
  };

  # Window States
  "super-n" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "focused"
      "-t"
      "tiled"
    ];
  };
  "super-d" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "focused"
      "-t"
      "floating"
    ];
  };
  "super-m" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "focused"
      "-t"
      "fullscreen"
    ];
  };

  # Navigation (Manual expansion of {h,j,k,l})
  "super-h" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-f"
      "west"
    ];
  };
  "super-j" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-f"
      "south"
    ];
  };
  "super-k" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-f"
      "north"
    ];
  };
  "super-l" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-f"
      "east"
    ];
  };

  # Swap Windows
  "super-shift-h" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-s"
      "west"
    ];
  };
  "super-shift-j" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-s"
      "south"
    ];
  };
  "super-shift-k" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-s"
      "north"
    ];
  };
  "super-shift-l" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-s"
      "east"
    ];
  };

  # Desktop Navigation (1-9 and 0 for 10)
  "super-1" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "1"
    ];
  };
  "super-2" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "2"
    ];
  };
  "super-3" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "3"
    ];
  };
  "super-4" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "4"
    ];
  };
  "super-5" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "5"
    ];
  };
  "super-6" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "6"
    ];
  };
  "super-7" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "7"
    ];
  };
  "super-8" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "8"
    ];
  };
  "super-9" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "9"
    ];
  };
  "super-0" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "desktop"
      "-f"
      "10"
    ];
  };

  # Move focused window to Desktop (Optional but common)
  "super-shift-1" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "1"
    ];
  };
  "super-shift-2" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "2"
    ];
  };
  "super-shift-3" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "3"
    ];
  };
  "super-shift-4" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "4"
    ];
  };
  "super-shift-5" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "5"
    ];
  };
  "super-shift-6" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "6"
    ];
  };
  "super-shift-7" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "7"
    ];
  };
  "super-shift-8" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "8"
    ];
  };
  "super-shift-9" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "9"
    ];
  };
  "super-shift-0" = {
    launch = [
      "${pkgs.bspwm}/bin/bspc"
      "node"
      "-d"
      "10"
    ];
  };
}
