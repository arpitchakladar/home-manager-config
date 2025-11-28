{ config, pkgs, lib, ... }:

{
	options.tools.bottom = {
		enable = lib.mkEnableOption "Enables bottom.";
	};

	config = lib.mkIf config.tools.bottom.enable {
		home.packages = with pkgs; [
			bottom
		];
	};
}
