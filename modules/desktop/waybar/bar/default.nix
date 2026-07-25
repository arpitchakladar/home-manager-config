{ config }:
{
  mainBar = import ./main.nix { inherit config; };
}
