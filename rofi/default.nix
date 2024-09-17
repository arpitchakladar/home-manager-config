{ config, ... }:

{
	programs.rofi = {
		enable = true;
		font = "FiraCode Nerd Font 16";
		theme = import ./theme.nix config;
	};
}
