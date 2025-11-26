{ config, lib, pkgs, ... }:

{
	options.tools.pamixer = {
		enable = lib.mkEnableOption "Enables pamixer.";
	};

	config = lib.mkIf config.tools.pamixer.enable {
		home.packages = [
			pkgs.pamixer
		];
	};
}
