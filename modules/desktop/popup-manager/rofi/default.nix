{ config, lib, ... }:

{
	options = {
		rofi.enable = lib.mkEnableOption "Enables rofi.";
	};

	config = lib.mkIf config.rofi.enable {
		programs.rofi.enable = true;
		programs.rofi.font = "FiraCode Nerd Font 16";
		programs.rofi.theme = import ./theme/default.nix config;
	};
}
