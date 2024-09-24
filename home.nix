{ pkgs, ... }:

{
	imports = [
		./base16
	];

	home.username = "arpit";
	home.homeDirectory = "/home/arpit";
	home.stateVersion = "23.11";

	# Desktop
	rofi.enable = true;
	polybar.enable = true;
	alacritty.enable = true;
	bspwm.enable = true;
	sxhkd.enable = true;
	xinit.enable = true;

	# Shell
	bash.enable = true;
	zsh.enable = true;

	# Tools
	neovim.enable = true;
	lf.enable = true;
	lsd.enable = true;
	git.enable = true;
	htop.enable = true;
	bat.enable = true;

	home.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];

	programs.home-manager.enable = true;
}
