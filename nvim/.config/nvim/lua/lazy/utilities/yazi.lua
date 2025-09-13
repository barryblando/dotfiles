return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/snacks.nvim",
	},
	keys = {
		{
			-- Open in the current working directory
			"<leader>z",
			"<cmd>Yazi cwd<cr>",
			desc = "File Manager (Yazi)",
		},
	},
	init = require("plugins.yazi").init,
	opts = require("plugins.yazi").opts,
}
