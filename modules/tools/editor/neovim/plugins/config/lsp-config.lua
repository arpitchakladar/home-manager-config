local lspconfig = require("lspconfig");

local filetype_to_lsp = {
	lua = { server = "lua_ls", executable = "lua-language-server" },
	cpp = { server = "clangd", executable = "clangd" },
	c = { server = "clangd", executable = "clangd" },
	python = { server = "pyright", executable = "pyright-langserver" },
	javascript = { server = "tsserver", executable = "typescript-language-server" },
	typescript = { server = "tsserver", executable = "typescript-language-server" },
	go = { server = "gopls", executable = "gopls" },
	html = { server = "html", executable = "vscode-html-language-server" },
	css = { server = "cssls", executable = "vscode-css-language-server" },
	json = { server = "jsonls", executable = "vscode-json-language-server" },
	bash = { server = "bashls", executable = "bash-language-server" },
	graphql = { server = "graphql", executable = "graphql-lsp" },
	dockerfile = { server = "dockerls", executable = "docker-langserver" },
	php = { server = "phpactor", executable = "phpactor" },
	rust = { server = "rust_analyzer", executable = "rust-analyzer" },
	haskell = { server = "hls", executable = "haskell-language-server-wrapper" },
	deno = { server = "denols", executable = "deno" },
	vim = { server = "vimls", executable = "vim-language-server" },
	elixir = { server = "elixirls", executable = "elixir-ls" },
	clojure = { server = "clojure_lsp", executable = "clojure-lsp" },
	scala = { server = "scala_metals", executable = "metals" },
	ruby = { server = "sorbet", executable = "srb" },
	zig = { server = "zls", executable = "zls" },
	kotlin = { server = "kotlin_language_server", executable = "kotlin-language-server" },
	java = { server = "jdtls", executable = "jdtls" },
	dart = { server = "dartls", executable = "dart" },
	yaml = { server = "yamlls", executable = "yaml-language-server" },
	perl = { server = "perlls", executable = "perl" },
	r = { server = "r_language_server", executable = "R" },
	tex = { server = "texlab", executable = "texlab" },
	swift = { server = "sourcekit", executable = "sourcekit-lsp" },
	svelte = { server = "svelteserver", executable = "svelteserver" },
	terraform = { server = "terraformls", executable = "terraform-ls" },
	vue = { server = "vls", executable = "vls" },
	markdown = { server = "marksman", executable = "marksman" },
	yaml = { server = "yamlls", executable = "yaml-language-server" },
};

-- Keeping track of all the lsps that have been already configured
local lsp_setup_done = {};

-- Function to setup LSP based on filetype
local function setup_lsp(filetype)
	local lsp = filetype_to_lsp[filetype];
	if lsp and not lsp_setup_done[lsp.server] then
		lsp_setup_done[lsp.server] = true;
		if vim.fn.executable(lsp.executable) then
			lspconfig[lsp.server].setup({});
			vim.lsp.start();
		end
	end
end

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true });
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true });
vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true });
vim.keymap.set("n", "gk", vim.lsp.buf.hover, { noremap = true, silent = true });

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*", -- Match all file types
	callback = function()
		setup_lsp(vim.bo.filetype); -- Call the setup_lsp function only if the filetype is in the mapping
	end,
});