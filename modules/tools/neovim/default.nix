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

	config =
	let
		plugins = import ./plugins { inherit config pkgs lib; };
	in lib.mkIf config.tools.neovim.enable {
		programs.neovim.enable = true;
		programs.neovim.viAlias = true;
		programs.neovim.vimAlias = true;
		programs.neovim.vimdiffAlias = true;
		programs.neovim.defaultEditor = true;

		home.packages = plugins.requirements;

		programs.neovim.extraLuaConfig =
	''
${import ./config}
${plugins.configuration}
	'';

		programs.neovim.plugins = plugins.list;
	};
}
