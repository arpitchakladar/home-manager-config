{ config }:

# Bar - Polybar bar definitions (main bar)
{
  "bar/main" = import ./main.nix { inherit config; };
}
