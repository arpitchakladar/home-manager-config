{ config, ... }:

{
	programs.rofi.enable = true;
	programs.rofi.font = "FiraCode Nerd Font 16";
	programs.rofi.theme = import ./theme.nix config;
}
