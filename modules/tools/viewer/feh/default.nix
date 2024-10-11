{ config, lib, pkgs, ... }:

{
	options.tools.viewer.feh = {
		enable = lib.mkEnableOption "Enables feh.";
	};

	config = lib.mkIf config.tools.viewer.feh.enable {
		programs.feh.enable = true;
	};
}
