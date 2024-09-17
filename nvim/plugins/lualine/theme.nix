config:

with config.lib.stylix.colors.withHashtag;
''
local theme = {
	normal = {
		a = { fg = "${base07}", bg = "${base0D}", gui = "bold" },
		b = { fg = "${base05}", bg = "${base01}" },
		c = { fg = "${base03}", bg = "${base00}" },
	},
	insert = { a = { fg = "${base07}", bg = "${base0B}", gui = "bold" } },
	visual = { a = { fg = "${base07}", bg = "${base0C}", gui = "bold" } },
	replace = { a = { fg = "${base07}", bg = "${base08}", gui = "bold" } },
	command = { a = { fg = "${base07}", bg = "${base0A}", gui = "bold" } },
}''
