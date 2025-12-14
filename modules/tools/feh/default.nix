{ config, lib, ... }:

{
	options.tools.feh = {
		enable = lib.mkEnableOption "Enables feh.";
	};

	config = lib.mkIf config.tools.feh.enable {
		programs.feh.enable = true;
	};
}
