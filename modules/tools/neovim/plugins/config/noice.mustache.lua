require("noice").setup();

vim.api.nvim_set_hl(0, "NoiceCommandOutput", { fg = "#{{base05-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceCmdline", { fg = "#{{base05-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = "#{{base05-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#{{base03-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceError", { fg = "#{{base08-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceWarning", { fg = "#{{base0A-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceInfo", { fg = "#{{base0C-hex}}", bg = "#{{base00-hex}}" });
vim.api.nvim_set_hl(0, "NoiceHint", { fg = "#{{base0B-hex}}", bg = "#{{base00-hex}}" });
