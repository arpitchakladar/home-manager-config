{ config, lib, pkgs, ... }:

{
	options.tools.neofetch = {
		enable = lib.mkEnableOption "Enables neofetch.";
	};

	config = lib.mkIf config.tools.neofetch.enable {
		home.packages = with pkgs; [
			neofetch
		];
	};
}
