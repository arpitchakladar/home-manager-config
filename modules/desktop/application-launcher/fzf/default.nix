{ config, lib, pkgs, ... }:

{
	options.desktop.application-launcher.fzf = {
		enable = lib.mkEnableOption "Enables fzf to be used as a application launcher.";
	};

	config = lib.mkIf config.desktop.application-launcher.fzf.enable {
		assertions = [
			{
				assertion = config.tools.fzf.enable;
				message ="Module desktop.application-launcher.fzf requires tools.fzf module to be enabled.";
			}
		];

		desktop.application-launcher.default = lib.mkDefault "fzf";
		desktop.application-launcher.command =
			if config.desktop.application-launcher.default == "fzf" then
				lib.mkForce "${config.desktop.terminal.command} --title 'Application Launcher' --class floating-termial -e ${(pkgs.writeShellScript "fzf-launch.sh" (builtins.readFile ./launch.sh))}"
			else "";
	};
}
