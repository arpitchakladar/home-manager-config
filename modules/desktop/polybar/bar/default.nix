{ config }:

{
  "bar/main" = import ./main.nix { inherit config; };
}
