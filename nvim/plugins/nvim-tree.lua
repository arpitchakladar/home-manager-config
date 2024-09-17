require("nvim-tree").setup {
	filters = {
		enable = false
	},
	renderer = {
		indent_markers = {
			enable = true
		},
		root_folder_label = function(path)
			return vim.fn.fnamemodify(path, ":t")
		end
	}
}
