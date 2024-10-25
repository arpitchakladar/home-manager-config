vim.g.mapleader = " ";
vim.g.maplocalleader = " ";

vim.o.clipboard = "unnamedplus";

vim.o.number = true;
vim.o.list = true;
vim.o.listchars = "tab:| ,trail:_,lead:_";

vim.o.laststatus = 3;

vim.o.signcolumn = "auto";
vim.opt.fillchars = { eob = " " };

vim.o.tabstop = 3;
vim.o.shiftwidth = 0;
vim.o.expandtab = false;

vim.o.updatetime = 300;

vim.o.mouse = "a";

-- Force all filetypes to use tabs
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.bo.expandtab = false;
		vim.bo.tabstop = 3;
		vim.bo.shiftwidth = 0;
	end,
});

-- Exception that use spaces
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml" },
	callback = function()
		vim.bo.expandtab = true;
		vim.bo.tabstop = 2;
		vim.bo.shiftwidth = 2;
	end,
});
