local lspconfig = require("lspconfig");

local filetype_to_lsp = {
	lua = "lua_ls",
	cpp = "clangd",
	c = "clangd",
	python = "pyright",
	javascript = "tsserver",
	typescript = "tsserver",
	go = "gopls",
	html = "html",
	css = "cssls",
	json = "jsonls",
	bash = "bashls",
	graphql = "graphql",
	dockerfile = "dockerls",
	php = "phpactor",
	rust = "rust_analyzer",
	haskell = "hls",
	deno = "denols",
	vim = "vimls",
	elixir = "elixirls",
	clojure = "clojure_lsp",
	scala = "scala_metals",
	ruby = "sorbet",
};

-- Keeping track of all the lsps that have been already configured
local lsp_setup_done = {};

-- Function to setup LSP based on filetype
local function setup_lsp(filetype)
	local lsp_server = filetype_to_lsp[filetype];
	if lsp_server and not lsp_setup_done[lsp_server] then
		lsp_setup_done[lsp_server] = true;
		lspconfig[lsp_server].setup({});
	end
end

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true });
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true });
vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true });
vim.keymap.set("i", "<C-c>", vim.lsp.buf.completion, { noremap = true, silent = true });
vim.keymap.set("n", "gk", vim.lsp.buf.hover, { noremap = true, silent = true });

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*", -- Match all file types
	callback = function()
		setup_lsp(vim.bo.filetype); -- Call the setup_lsp function only if the filetype is in the mapping
	end,
});
