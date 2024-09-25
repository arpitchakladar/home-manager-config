vim.o.termguicolors = true;
vim.opt.termguicolors = true;
vim.o.background = "dark";
vim.g.base16colorspace = 256
vim.cmd.colorscheme("base16-scheme");

-- Overrides
-- disable the background of line numbers
vim.api.nvim_set_hl(0, "LineNr", { link = "Normal" });

-- change the color of the pane separator
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#{{base02-hex}}", bg = "None" });
