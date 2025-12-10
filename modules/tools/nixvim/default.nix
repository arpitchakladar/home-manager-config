{ pkgs, config, lib, ... }:

let
	nixvim = import (builtins.fetchGit {
		url = "https://github.com/nix-community/nixvim";
	});
in {
	imports = [
		nixvim.homeModules.nixvim
	];

	options.tools.nixvim = {
		enable = lib.mkEnableOption "Enables nixvim.";
	};

	config = lib.mkIf config.tools.nixvim.enable
	{
		programs.nixvim = {
			enable = true;
			colorschemes.base16 = {
				enable = true;
				colorscheme = with config.scheme.withHashtag; {
					base00 = base00;
					base01 = base01;
					base02 = base02;
					base03 = base03;
					base04 = base04;
					base05 = base05;
					base06 = base06;
					base07 = base07;
					base08 = base08;
					base09 = base09;
					base0A = base0A;
					base0B = base0B;
					base0C = base0C;
					base0D = base0D;
					base0E = base0E;
					base0F = base0F;
				};
			};
			opts = {
				number = true;
				relativenumber = true;
				shiftwidth = 3;
			};
			plugins = {
				lightline = {
					enable = true;
				};
			};
		};
	};
}
