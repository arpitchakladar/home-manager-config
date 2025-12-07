{ config, lib, pkgs, ... }:

{
	config = {
		home.sessionPath = [
			"${config.home.homeDirectory}/scripts"
		];

		home.file."scripts/system-monitor" =
			lib.mkIf
				(config.tools.bottom.enable &&
				config.tools.nvtop.enable &&
				config.tools.tmux.enable &&
				config.tools.kitty.enable)
		{
			text = ''
#!${pkgs.bash}/bin/bash
${builtins.readFile ./system-monitor.sh}
'';
			executable = true;
		};
	};
}
