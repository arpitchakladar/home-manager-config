{ config, pkgs, lib, ... }:

{
	options.tools.file-manager.lf = {
		enable = lib.mkEnableOption "Enables lf.";
	};

	config = lib.mkIf config.tools.file-manager.lf.enable {
		tools.file-manager.default = lib.mkDefault "lf";
		tools.file-manager.command =
			if config.tools.file-manager.default == "lf" then
				lib.mkForce "${pkgs.lf}/bin/lf"
			else "";

		programs.lf.enable = true;
		programs.lf.settings = {
			hidden = true;
		};
		programs.lf.previewer.source = pkgs.writeShellScript
			"previewer.sh"
			''
#!/bin/sh
unset COLORTERM
${if config.tools.viewer.bat.enable then
	"bat -pp --line-range=:500 --color=always $1"
else "cat"}
			'';
		programs.lf.extraConfig = "set icons";

		xdg.configFile."lf/icons".source = ./icons;
	};
}
