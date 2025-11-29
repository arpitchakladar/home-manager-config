{ pkgs, lib, config, ... }:

{
	options.tools.htop = {
		enable = lib.mkEnableOption "Enables htop.";
	};

	config = lib.mkIf config.tools.htop.enable {
		programs.htop = {
			enable = true;
			package = pkgs.htop-vim;
		};
	};
}
