{ config, pkgs, ... }:

{
	programs.lf.enable = true;
	programs.lf.settings = {
		hidden = true;
	};
	programs.lf.previewer.source = pkgs.writeShellScript
		"previewer.sh"
		(builtins.readFile ./scripts/previewer.sh);

	programs.lf.extraConfig = "set icons";

	xdg.configFile."lf/icons".source = ./icons;
}
