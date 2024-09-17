# Using the stylix to have a consistent colorscheme
config:

with config.lib.stylix.colors.withHashtag;
''
-- Apply the color scheme
vim.cmd("highlight clear")
vim.cmd("syntax reset")

-- Set terminal colors
vim.g.terminal_color_0 = "${base00}"
vim.g.terminal_color_1 = "${base08}"
vim.g.terminal_color_2 = "${base0B}"
vim.g.terminal_color_3 = "${base0A}"
vim.g.terminal_color_4 = "${base0D}"
vim.g.terminal_color_5 = "${base0E}"
vim.g.terminal_color_6 = "${base0C}"
vim.g.terminal_color_7 = "${base05}"
vim.g.terminal_color_8 = "${base03}"
vim.g.terminal_color_9 = "${base08}"
vim.g.terminal_color_10 = "${base0B}"
vim.g.terminal_color_11 = "${base0A}"
vim.g.terminal_color_12 = "${base0D}"
vim.g.terminal_color_13 = "${base0E}"
vim.g.terminal_color_14 = "${base0C}"
vim.g.terminal_color_15 = "${base07}"

-- Set highlight groups
vim.api.nvim_set_hl(0, "Normal", { fg = "${base05}", bg = "${base00}" })
vim.api.nvim_set_hl(0, "Comment", { fg = "${base03}", bg = "${base00}", italic = true })
vim.api.nvim_set_hl(0, "Constant", { fg = "${base09}" })
vim.api.nvim_set_hl(0, "String", { fg = "${base0B}" })
vim.api.nvim_set_hl(0, "Identifier", { fg = "${base08}" })
vim.api.nvim_set_hl(0, "Function", { fg = "${base0D}" })
vim.api.nvim_set_hl(0, "Statement", { fg = "${base0E}" })
vim.api.nvim_set_hl(0, "Keyword", { fg = "${base0E}" })
vim.api.nvim_set_hl(0, "Type", { fg = "${base0A}" })
vim.api.nvim_set_hl(0, "Special", { fg = "${base0C}" })
vim.api.nvim_set_hl(0, "PreProc", { fg = "${base0A}" })
vim.api.nvim_set_hl(0, "Underlined", { fg = "${base0B}", underline = true })
vim.api.nvim_set_hl(0, "Error", { fg = "${base08}", bg = "${base00}", bold = true })
vim.api.nvim_set_hl(0, "Todo", { fg = "${base0A}", bg = "${base00}", bold = true })
''
