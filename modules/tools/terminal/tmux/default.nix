{ pkgs, config, lib, ... }:

{
	options.tools.terminal.tmux = {
		enable = lib.mkEnableOption "Enables tmus.";
	};

	config = lib.mkIf config.tools.terminal.tmux.enable {
		programs.tmux.enable = true;
	};
}
