{ config, lib }:

{
	"bar/main" = import ./main.nix { inherit config lib; };
}
