# Development - Development tools module (bruno, delta, git, lazygit, nixvim, opencode, qemu, vscodium)
{ ... }:

{
  imports = [
    ./bruno
    ./delta
    ./git
    ./lazygit
    ./nixvim
    ./opencode
    ./qemu
    ./vscodium
  ];
}
