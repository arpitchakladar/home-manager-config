{ config, ... }:

{
	home.username = "arpit";
	home.homeDirectory = "/home/${config.home.username}";
	home.stateVersion = "25.05";

	# Fonts
	fonts.nerdfont.fira-code.enable = true;

	# Graphics
	graphical.enable = true;

	# Enable scripts
	scripts.enable = true;

	# Tools
	tools.acpi.enable = true;
	tools.bat.enable = true;
	tools.brave.enable = true;
	tools.brightnessctl.enable = true;
	tools.feh.enable = true;
	tools.fzf.enable = true;
	tools.git.enable = true;
	tools.git.username = "Arpit Chakladar";
	tools.git.email = "54011232+arpitchakladar@users.noreply.github.com";
	tools.htop.enable = true;
	tools.kitty.enable = true;
	tools.lsd.enable = true;
	tools.neofetch.enable = true;
	tools.neovim.enable = true;
	tools.neovim.profile = "full";
	tools.nnn.enable = true;
	tools.pamixer.enable = true;
	tools.playerctl.enable = true;
	tools.rofi.enable = true;
	tools.zsh.enable = true;

	programs.home-manager.enable = true;
}
