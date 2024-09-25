{ config }:

''
require("nvim-treesitter.configs").setup {
	auto_install = true,
	highlight = {
		enable = true,
	},
	parser_install_dir = "${config.xdg.dataHome}/nvim",
};

vim.opt.runtimepath:append("${config.xdg.dataHome}/nvim");
''
