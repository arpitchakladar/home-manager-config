{ config, lib }:

{
	"module/separator" = import ./separator.nix { inherit config; };
	"module/xwindow" = import ./xwindow.nix { inherit config; };
	"module/bspwm" = import ./bspwm.nix { inherit config; };
	"module/cpu" = import ./cpu.nix { inherit config; };
	"module/memory" = import ./memory.nix { inherit config; };
	"module/date" = import ./date.nix { inherit config; };
	"module/time" = import ./time.nix { inherit config; };
	"module/volume" = import ./volume.nix { inherit config; };
	"module/battery" = import ./battery.nix { inherit config; };
	"module/kernel-version" = import ./kernel-version.nix { inherit config; };
}
