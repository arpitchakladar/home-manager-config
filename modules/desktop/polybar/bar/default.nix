# Bar - Polybar bar definitions (main bar)
{ config }:
{
  "bar/main" = import ./main.nix { inherit config; };
}
