require("ufo").setup {
	provider_selector = function(bufnr, filetype, buftype)
		return {
			"treesitter",
			"indent"
		}
	end,
};

vim.o.foldenable = true
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99      -- Ensure all folds start open
vim.o.foldlevelstart = 99

-- press <Shift>K or capslockK
vim.keymap.set("n", "<S-K>", function()
	local winid = ufo.peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end)
