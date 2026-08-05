# Terminal emulator and shell modules
{ ... }:

{
  imports = [
    ./bash
    ./bat
    ./fzf
    ./kitty
    ./less
    ./starship
    ./tmux
    ./zsh
  ];
}
