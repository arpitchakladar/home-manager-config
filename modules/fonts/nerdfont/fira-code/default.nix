{ lib, config, pkgs, ... }:

{
	options.fonts.nerdfont.fira-code = {
		enable = lib.mkEnableOption "Enables fira code nerd font.";
	};

	config = lib.mkIf config.fonts.nerdfont.fira-code.enable {
		fonts.normal = lib.mkDefault "Fira Code Nerd Font";

		home.packages = with pkgs; [
			nerd-fonts.fira-code
		];
	};
}
