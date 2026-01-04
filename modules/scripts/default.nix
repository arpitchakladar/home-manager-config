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
			"scripts/system-monitor" =
				lib.mkIf
					(config.tools.bottom.enable &&
					config.tools.nvtop.enable &&
					config.tools.tmux.enable &&
					config.tools.kitty.enable)
				(shellScript ./system-monitor.sh);
			"scripts/warp-start" =
				lib.mkIf
					config.tools.cloudflare-warp.enable
				(shellScript ./warp-start.sh);
			"scripts/warp-stop" =
				lib.mkIf
					config.tools.cloudflare-warp.enable
				(shellScript ./warp-stop.sh);
		};
	};
}
