{ config, lib, pkgs, ... }:

{
	options.shell.zsh = {
		enable = lib.mkEnableOption "Enables zsh.";
	};

	config = lib.mkIf config.shell.zsh.enable {
		shell.default = "${pkgs.zsh}/bin/zsh";

		programs.zsh.enable = true;
		programs.zsh.dotDir = ".config/zsh";
		programs.zsh.history.path = "${config.xdg.cacheHome}/zsh/history";
		programs.zsh.initExtra = builtins.readFile ./zshrc;
		programs.zsh.shellAliases = config.shell.alias;
	};
}
