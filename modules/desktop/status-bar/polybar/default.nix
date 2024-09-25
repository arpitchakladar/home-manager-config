{ config, lib, ... }:

{
	options.desktop.status-bar.polybar = {
		enable = lib.mkEnableOption "Enables polybar.";
	};

	config = lib.mkIf config.desktop.status-bar.polybar.enable {
		services.polybar.enable = true;
		services.polybar.script = "polybar main &";

		services.polybar.config = {
			"bar/main" = import ./bars/main.nix { inherit config; };
			"module/xwindow" = import ./modules/xwindow.nix { inherit config; };
			"module/bspwm" =
				if config.desktop.window-manager.bspwm.enable then
					import ./modules/bspwm.nix { inherit config; }
				else null;
			"module/cpu" = import ./modules/cpu.nix { inherit config; };
			"module/memory" = import ./modules/memory.nix { inherit config; };
			"module/date" = import ./modules/date.nix { inherit config; };
			"module/time" = import ./modules/time.nix { inherit config; };
			"module/battery" = import ./modules/battery.nix { inherit config; };
			"module/kernel-version" = import ./modules/kernel-version.nix { inherit config; };
		};
	};
}
