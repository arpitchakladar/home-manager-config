{ config, lib, ... }:

{
	options.desktop.status-bar.polybar = {
		enable = lib.mkEnableOption "Enables polybar.";
		command = lib.mkOption {
			type = lib.types.str;
			description = "Command to run polybar.";
			# This command calculates the width of the polybar to create those gaps
			default = ''
MONITOR_WIDTH=$(xrandr | grep '*' | awk '{print $1}' | cut -d'x' -f1 | head -n1); \
OFFSET=${toString config.desktop.window-manager.gap}; \
POLYBAR_WIDTH=$((MONITOR_WIDTH - 2 * OFFSET)) POLYBAR_OFFSET=$OFFSET polybar main &
'';
		};
	};

	config = lib.mkIf config.desktop.status-bar.polybar.enable {
		services.polybar.enable = true;
		services.polybar.script = config.desktop.status-bar.polybar.command;

		services.polybar.config = {
			"bar/main" = import ./bar/main.nix { inherit config; };
			"module/xwindow" = import ./module/xwindow.nix { inherit config; };
			"module/bspwm" =
				if config.desktop.window-manager.bspwm.enable then
					import ./module/bspwm.nix { inherit config; }
				else null;
			"module/cpu" = import ./module/cpu.nix { inherit config; };
			"module/memory" = import ./module/memory.nix { inherit config; };
			"module/date" = import ./module/date.nix { inherit config; };
			"module/time" = import ./module/time.nix { inherit config; };
			"module/battery" = import ./module/battery.nix { inherit config; };
			"module/kernel-version" = import ./module/kernel-version.nix { inherit config; };
		};
	};
}
