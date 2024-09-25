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
	desktop.window-manager.bspwm.enable = true;
	desktop.window-manager.sxhkd.enable = true;

	# Shell
	shell.bash.enable = true;
	shell.zsh.enable = true;

	# Tools
	tools.editor.neovim.enable = true;
	# tools.file-manager.lf.enable = true;
	tools.file-manager.nnn.enable = true;
	tools.file-manager.lsd.enable = true;
	tools.git.enable = true;
	tools.system-monitor.htop.enable = true;
	tools.viewer.bat.enable = true;

	home.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];

	programs.home-manager.enable = true;
}
