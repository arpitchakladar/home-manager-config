{ config, lib, ... }:

{
	options.tools.tmux = {
		enable = lib.mkEnableOption "Enables tmux.";
	};

	config = lib.mkIf config.tools.tmux.enable {
		programs.tmux.enable = true;
	};
}
