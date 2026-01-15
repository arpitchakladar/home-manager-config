{ config, lib, ... }:

{
	options.tools.bottom = {
		enable = lib.mkEnableOption "Enables bottom.";
	};

	config = lib.mkIf config.tools.bottom.enable {
		programs.bottom.enable = true;
	};
}
