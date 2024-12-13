{ pkgs, lib, config, ... }:

{
	options.tools.git.git-cola = {
		enable = lib.mkEnableOption "Enables git.git-colakraken.";
	};

	config = lib.mkIf config.tools.git.git-cola.enable {
		assertions = [
			{
				assertion = config.tools.git.enable;
				message ="Module tools.git.git-cola requires tools.git module to be enabled.";
			}
		];

		home.packages = with pkgs; [
			git-cola
		];
	};
}
