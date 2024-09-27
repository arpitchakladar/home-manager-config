{ pkgs, ... }:

{
	home.username = "arpit";
	home.homeDirectory = "/home/arpit";
	home.stateVersion = "23.11";

	# Desktop
	desktop.display-server.x11.xinit.enable = true;
	desktop.popup-manager.rofi.enable = true;
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
	tools.file-manager.lf.enable = true;
	tools.file-manager.nnn.enable = true;
	tools.file-manager.default = "nnn";
	tools.file-manager.lsd.enable = true;
	tools.git.enable = true;
	tools.system-monitor.htop.enable = true;
	tools.viewer.bat.enable = true;

	programs.home-manager.enable = true;
}
