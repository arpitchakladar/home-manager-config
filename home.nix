{ pkgs, ... }:

{
	home.username = "arpit";
	home.homeDirectory = "/home/arpit";
	home.stateVersion = "23.11";

	# Desktop
	desktop.display-server.x11.xinit.enable = true;
	desktop.application-launcher.rofi.enable = true;
	desktop.application-launcher.fzf.enable = true;
	desktop.application-launcher.default = "fzf";
	desktop.status-bar.polybar.enable = true;
	desktop.terminal.alacritty.enable = true;
	desktop.terminal.kitty.enable = true;
	desktop.terminal.default = "kitty";
	desktop.window-manager.bspwm.enable = true;
	desktop.window-manager.sxhkd.enable = true;
	desktop.xdg-portal.enable = true;

	# Fonts
	fonts.nerdfont.fira-code.enable = true;

	# Shell
	shell.bash.enable = true;
	shell.zsh.enable = true;
	shell.default = "zsh";

	# Tools
	tools.editor.neovim.enable = true;
	tools.editor.neovim.configuration = "full";
	tools.file-manager.lf.enable = true;
	tools.file-manager.nnn.enable = true;
	tools.file-manager.default = "nnn";
	tools.file-manager.lsd.enable = true;
	tools.git.enable = true;
	tools.git.username = "Arpit Chakladar";
	tools.git.email = "54011232+arpitchakladar@users.noreply.github.com";
	tools.system-monitor.htop.enable = true;
	tools.utils.fzf.enable = true;
	tools.viewer.bat.enable = true;

	programs.home-manager.enable = true;
}
