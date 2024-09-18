{ config, pkgs, ... }:

{
	imports = [
		./stylix/default.nix
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
	];
	# Home Manager needs a bit of information about you and the paths it should
	# manage.
	home.username = "arpit";
	home.homeDirectory = "/home/arpit";

	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "23.11"; # Please read the comment before changing.

	home.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	programs.home-manager.enable = true;
}
