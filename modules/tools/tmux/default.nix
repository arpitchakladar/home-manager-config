{ config, pkgs, lib, ... }:

{
	options.tools.tmux = {
		enable = lib.mkEnableOption "Enables tmux.";
	};

	config = lib.mkIf config.tools.tmux.enable {
		home.packages = with pkgs; [
			tmux
		];
	};
}
