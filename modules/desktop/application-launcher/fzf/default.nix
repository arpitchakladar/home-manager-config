{ config, lib, pkgs, ... }:

{
	options.desktop.application-launcher.fzf = {
		enable = lib.mkEnableOption "Enables fzf to be used as a application launcher.";
	};

	config = lib.mkIf config.desktop.application-launcher.fzf.enable {
		assertions = [
			{
				assertion = config.tools.utils.fzf.enable;
				message ="Module desktop.application-launcher.fzf requires tools.utils.fzf module to be enabled.";
			}
		];

		desktop.application-launcher.default = lib.mkDefault "fzf";
		desktop.application-launcher.command =
			lib.mkIf
				(config.desktop.application-launcher.default == "fzf")
				"${config.tools.terminal.command} --title 'Application Launcher' --class floating-termial -e ${(pkgs.writeShellScript "fzf-launch.sh" (builtins.readFile ./launch.sh))}";
	};
}
