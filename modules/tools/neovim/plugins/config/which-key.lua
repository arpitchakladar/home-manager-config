local wk = require("which-key");

vim.keymap.set("n", "<leader>h", function()
	wk.show({ global = true })
end, { silent = true });
