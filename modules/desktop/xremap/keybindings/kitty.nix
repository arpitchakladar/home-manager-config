{ pkgs }:

{

  "super-t" = {
    launch = [ "${pkgs.kitty}/bin/kitty" ];
  };
  "super-f" = {
    launch = [
      "${pkgs.kitty}/bin/kitty"
      "--title"
      "File Manager"
      "--class"
      "floating-terminal"
      "-e"
      "nnn"
    ];
  };
  "super-s" = {
    launch = [
      "${pkgs.kitty}/bin/kitty"
      "--title"
      "Keybindings"
      "--class"
      "floating-terminal"
      "-e"
      "keybindings.sh"
    ];
  };
}
