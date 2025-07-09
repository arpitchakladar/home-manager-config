{ config, lib, ... }:

{
	options.tools.lsd = {
		enable = lib.mkEnableOption "Enables lsd.";
	};

	config = lib.mkIf config.tools.lsd.enable {
		programs.lsd.enable = true;
		programs.lsd.settings.icons.separator = "  ";
	};
}
