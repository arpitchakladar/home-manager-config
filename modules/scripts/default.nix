{ config, lib, pkgs, ... }:

{
	options.scripts = {
		enable = lib.mkEnableOption "Enable scripts.";
	};

	config = lib.mkIf config.scripts.enable {
		home.sessionPath = [
			"${config.home.homeDirectory}/scripts"
		];

		home.file."scripts/restart-network" = {
			source = ./restart-network.sh;
			executable = true;
		};
		home.file."scripts/system-monitor" =
			lib.mkIf
				(config.tools.bottom.enable &&
				config.tools.nvtop.enable &&
				config.tools.tmux.enable &&
				config.tools.kitty.enable)
		{
			source = ./system-monitor.sh;
			executable = true;
		};
	};
}
