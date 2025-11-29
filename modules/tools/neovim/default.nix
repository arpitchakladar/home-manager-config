{ pkgs, config, lib, ... }:

{
	options.tools.neovim = {
		enable = lib.mkEnableOption "Enables neovim.";
		profile = lib.mkOption {
			type = lib.types.enum [
				"minimal"
				"full"
			];
			default = "minimal";
			description = "The profile for neovim to use.";
		};
	};

	config = let
		plugins = import ./plugins { inherit config pkgs lib; };
	in lib.mkIf config.tools.neovim.enable {
		programs.neovim = {
			enable = true;
			viAlias = true;
			vimAlias = true;
			vimdiffAlias = true;
			defaultEditor = true;
			plugins = plugins.list;
			extraLuaConfig =
	''
${import ./config}
${plugins.configuration}
	'';
		};

		home.packages = plugins.requirements;
	};
}
