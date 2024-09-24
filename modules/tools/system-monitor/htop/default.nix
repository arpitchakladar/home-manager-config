{ pkgs, lib, config, ... }:

{
	options.tools.system-monitor.htop = {
		enable = lib.mkEnableOption "Enables htop.";
	};

	config = lib.mkIf config.tools.system-monitor.htop.enable {
		programs.htop.enable = true;
		programs.htop.package = pkgs.htop-vim;
	};
}
