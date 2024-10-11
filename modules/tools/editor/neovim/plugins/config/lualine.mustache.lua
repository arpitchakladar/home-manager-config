local lualine_theme = {
	normal = {
		a = { fg = "#{{base0D-hex}}", bg = "none", gui = "bold" },
		b = { fg = "#{{base05-hex}}", bg = "none" },
		c = { fg = "#{{base05-hex}}", bg = "none" },
	},
	insert = {
		a = { fg = "#{{base0B-hex}}", bg = "none", gui = "bold" },
	},
	visual = {
		a = { fg = "#{{base0E-hex}}", bg = "none", gui = "bold" },
	},
	replace = {
		a = { fg = "#{{base08-hex}}", bg = "none", gui = "bold" },
	},
	command = {
		a = { fg = "#{{base0A-hex}}", bg = "none", gui = "bold" },
	},
	inactive = {
		a = { fg = "#{{base04-hex}}", bg = "none" },
		b = { fg = "#{{base04-hex}}", bg = "none" },
		c = { fg = "#{{base04-hex}}", bg = "none" },
	},
};

local function macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register ~= "" then
		return "@" .. recording_register
	else
		return ""
	end
end

require("lualine").setup {
	options = {
		icons_enabled = true,
		theme = lualine_theme,
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			{
				"diff",
				colored = true,
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				}
			}
		},
		lualine_c = { "filename" },
		lualine_x = { macro_recording, "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
};
