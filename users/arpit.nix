{ config, ... }:

{
	nixpkgs.config.allowUnfree = true;

	home.username = "arpit";
	home.homeDirectory = "/home/${config.home.username}";
	home.stateVersion = "25.05";

	# Desktop environment
	desktop.enable = true;

	# Tools
	tools.atac.enable = true;
	tools.bluetui.enable = true;
	tools.bottles.enable = true;
	tools.bottom.enable = true;
	tools.brightnessctl.enable = true;
	tools.feh.enable = true;
	tools.fzf.enable = true;
	tools.git.enable = true;
	tools.git.username = "Arpit Chakladar";
	tools.git.email = "54011232+arpitchakladar@users.noreply.github.com";
	tools.htop.enable = true;
	tools.impala.enable = true;
	tools.kitty.enable = true;
	tools.libreoffice.enable = true;
	tools.librewolf.enable = true;
	tools.lsd.enable = true;
	tools.neofetch.enable = true;
	tools.nixvim.enable = true;
	tools.nnn.enable = true;
	tools.nvtop.enable = true;
	tools.pamixer.enable = true;
	tools.playerctl.enable = true;
	tools.rofi.enable = true;
	tools.tmux.enable = true;
	tools.unar.enable = true;
	tools.vlc.enable = true;
	tools.zsh.enable = true;

	programs.home-manager.enable = true;
}
