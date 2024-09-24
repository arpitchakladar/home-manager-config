vim.o.termguicolors = true;
vim.opt.termguicolors = true;
vim.o.background = "dark";
vim.g.base16colorspace = 256
vim.cmd.colorscheme("base16-scheme");
vim.api.nvim_set_hl(0, "LineNr", { link = "Normal" }); -- disable the background of line numbers
