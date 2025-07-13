{ pkgs, lib, config, ... }:

{
	options.tools.rofi = {
		enable = lib.mkEnableOption "Enables rofi.";
	};

	config = lib.mkIf config.tools.rofi.enable {
		programs.rofi.enable = true;
		programs.rofi.font = "${config.fonts.normal} ${toString config.fonts.size}";
		# programs.rofi.theme = config.scheme {
		# 	template = builtins.readFile ./theme.mustache.rasi;
		# };
	};
}
