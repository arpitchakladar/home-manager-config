# Development tools module
{ ... }:

{
  imports = [
    ./bruno
    ./delta
    ./direnv
    ./git
    ./lazygit
    ./nixvim
    ./opencode
    ./qemu
    ./ripgrep
    ./vscodium
  ];
}
