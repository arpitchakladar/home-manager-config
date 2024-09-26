{ lib, config, pkgs, ... }:

{
	options.fonts.nerdfont = {
		enable = lib.mkEnableOption "Enables bash.";
	};

	config = lib.mkIf config.fonts.nerdfont.enable {
		fonts.normal = lib.mkDefault "Fira Code Nerd Font";
		home.packages = with pkgs; [
			(nerdfonts.override {
				fonts = [
					"FiraCode"
				];
			})
		];
	};
}
