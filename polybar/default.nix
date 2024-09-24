{ config, ... }:

{
	services.polybar.enable = true;
	services.polybar.script = "polybar main &";

	services.polybar.config = {
		"bar/main" = import ./bars/main.nix config;
		"module/xwindow" = import ./modules/xwindow.nix config;
		"module/bspwm" = import ./modules/bspwm.nix config;
		"module/cpu" = import ./modules/cpu.nix config;
		"module/memory" = import ./modules/memory.nix config;
		"module/date" = import ./modules/date.nix config;
		"module/time" = import ./modules/time.nix config;
		"module/battery" = import ./modules/battery.nix config;
		"module/kernel-version" = import ./modules/kernel-version.nix config;
	};
}
