{ pkgs, lib, config, ... }:

{
	options = {
		htop.enable = lib.mkEnableOption "Enables htop.";
	};

	config = lib.mkIf config.htop.enable {
		programs.htop.enable = true;
		programs.htop.package = pkgs.htop-vim;
	};
}
