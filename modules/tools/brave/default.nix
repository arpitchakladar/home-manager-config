{ config, lib, pkgs, ... }:

{
	options.tools.brave = {
		enable = lib.mkEnableOption "Enables brave.";
	};

	config = lib.mkIf config.tools.brave.enable {
		home.packages = [
			pkgs.brave
		];
	};
}
