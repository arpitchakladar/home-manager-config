# Security tools
{ ... }:

{
  imports = [
    ./gopass
    ./gpg
    ./gpg-tui
    ./ssh
  ];
}
