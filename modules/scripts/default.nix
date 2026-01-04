{ config, lib, pkgs, ... }:

{
	config = {
		home.sessionPath = [
			"${config.home.homeDirectory}/scripts"
		];

		home.file = let
			shellScript = path: {
				text = ''
#!${pkgs.bash}/bin/bash
${builtins.readFile path}
'';
				executable = true;
			};
		in {
			"scripts/system-monitor" = shellScript ./system-monitor.sh;
			"scripts/warp-start" = shellScript ./warp-start.sh;
			"scripts/warp-stop" = shellScript ./warp-stop.sh;
		};
	};
}
