{ pkgs, ... }:

{
	imports = [
		./base16/default.nix
		./bspwm/default.nix
		./sxhkd/default.nix
		./polybar/default.nix
		./git/default.nix
		./xresources/default.nix
		./zsh/default.nix
		./bash/default.nix
		./alacritty/default.nix
		./nvim/default.nix
		./lf/default.nix
		./rofi/default.nix
		./htop/default.nix
		./lsd/default.nix
		./bat/default.nix
	];
	home.username = "arpit";
	home.homeDirectory = "/home/arpit";
	home.stateVersion = "23.11";

	home.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];

	programs.home-manager.enable = true;
}
