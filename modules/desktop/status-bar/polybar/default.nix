{ config, lib, pkgs, ... }:

let
	polybarPackage = pkgs.polybar.override {
		i3Support = config.desktop.window-manager.i3.enable;
	};
in
{
	options.desktop.status-bar.polybar = {
		enable = lib.mkEnableOption "Enables polybar.";
		command = lib.mkOption {
			type = lib.types.str;
			description = "Command to run polybar.";
			# This command calculates the width of the polybar to create those gaps
			default = toString (pkgs.writeShellScript "polybar-run.sh" ''
#!/bin/sh

MONITOR_WIDTH=$(xrandr | grep '*' | awk '{print $1}' | cut -d'x' -f1 | head -n1)
OFFSET=${toString config.desktop.window-manager.gap}
POLYBAR_WIDTH=$((MONITOR_WIDTH - 2 * OFFSET)) POLYBAR_OFFSET=$OFFSET ${polybarPackage}/bin/polybar main &
'');
		};
	};

	config = lib.mkIf config.desktop.status-bar.polybar.enable {
		services.polybar.enable = true;
		services.polybar.script = config.desktop.status-bar.polybar.command;
		services.polybar.package = polybarPackage;
		services.polybar.config = lib.mkMerge [
			(import ./bar { inherit config lib; })
			(import ./module { inherit config lib; })
		];
	};
}
