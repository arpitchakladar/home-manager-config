{ config, ... }:

{
	home.username = "arpit";
	home.homeDirectory = "/home/arpit";
	home.stateVersion = "23.11";

	baseDirectory = "${config.home.homeDirectory}/home-manager";

	# Desktop
	desktop.display-server.x11.xclip.enable = true;
	desktop.display-server.x11.xinit.enable = true;
	desktop.application-launcher.rofi.enable = false;
	desktop.application-launcher.fzf.enable = true;
	desktop.application-launcher.default = "fzf";
	desktop.display-server.compositor.picom.enable = false;
	desktop.status-bar.polybar.enable = true;
	desktop.window-manager.bspwm.enable = true;
	desktop.window-manager.sxhkd.enable = true;
	desktop.window-manager.i3.enable = false;
	desktop.window-manager.default = "bspwm";
	desktop.xdg.portal.enable = false;

	# Fonts
	fonts.nerdfont.fira-code.enable = true;

	scripts.enable = true;

	# Shell
	shell.bash.enable = true;
	shell.zsh.enable = true;
	shell.default = "zsh";

	# Tools
	tools.editor.neovim.enable = true;
	tools.editor.neovim.profile = "full";
	tools.file-manager.lf.enable = false;
	tools.file-manager.nnn.enable = true;
	tools.file-manager.default = "nnn";
	tools.file-manager.lsd.enable = true;
	tools.git.enable = true;
	tools.git.username = "Arpit Chakladar";
	tools.git.email = "54011232+arpitchakladar@users.noreply.github.com";
	tools.system-monitor.htop.enable = true;
	tools.terminal.alacritty.enable = false;
	tools.terminal.kitty.enable = true;
	tools.terminal.tmux.enable = true;
	tools.terminal.default = "kitty";
	tools.utils.fzf.enable = true;
	tools.viewer.bat.enable = true;
	tools.viewer.feh.enable = true;

	programs.home-manager.enable = true;
}
