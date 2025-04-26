return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	-- event = "VeryLazy",
	init = function()
		vim.ui.select = require("dropbar.utils.menu").select
	end,
	opts = require("plugins.dropbar").opts,
	config = require("plugins.dropbar").config,
}
