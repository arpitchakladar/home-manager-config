{ config, lib, pkgs, ... }:

{
	options.tools.feh = {
		enable = lib.mkEnableOption "Enables feh.";
	};

	config = lib.mkIf config.tools.git.enable {
		programs.feh.enable = true;
	};
}
