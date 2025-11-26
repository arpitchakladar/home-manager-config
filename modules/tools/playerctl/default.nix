{ config, lib, pkgs, ... }:

{
	options.tools.playerctl = {
		enable = lib.mkEnableOption "Enables playerctl.";
	};

	config = lib.mkIf config.tools.playerctl.enable {
		home.packages = [
			pkgs.playerctl
		];
	};
}
