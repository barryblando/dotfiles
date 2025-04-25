return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	-- commit = "1424449",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		{
			-- only needed if you want to use the commands with "_with_window_picker" suffix
			"s1n7ax/nvim-window-picker",
			name = "window-picker",
			event = "VeryLazy",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal" },
						},
					},
					other_win_hl_color = "#e35e4f",
				})
			end,
		},
	},
	config = require("plugins.neo-tree").config,
}
