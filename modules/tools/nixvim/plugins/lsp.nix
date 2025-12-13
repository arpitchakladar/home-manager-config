{ config, lib, ... }:

{
	config.programs.nixvim.plugins.lsp = lib.mkIf config.tools.nixvim.enable {
		enable = true;
		servers = {
			nil_ls = {
				enable = true;
			};
			lua_ls = {
				enable = true;
				package = null;
			};
			nixd = {
				enable = true;
				package = null;
			};
			pyright = {
				enable = true;
				package = null;
			};
			ts_ls = {
				enable = true;
				package = null;
			};
			clangd = {
				enable = true;
				package = null;
			};
			jsonls = {
				enable = true;
				package = null;
			};
			yamlls = {
				enable = true;
				package = null;
			};
			bash-language-server = {
				enable = true;
				package = null;
			};
		};
	};
}
