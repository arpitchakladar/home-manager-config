{ config, lib, pkgs, ... }:

{
	options.tools.brightnessctl = {
		enable = lib.mkEnableOption "Enables brightnessctl.";
	};

	config = lib.mkIf config.tools.brightnessctl.enable {
		home.packages = [
			pkgs.brightnessctl
		];
	};
}
