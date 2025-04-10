return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	depedencies = {
		-- Mini Icons alternative to web-devicons
		{ "echasnovski/mini.icons", version = false },
	},
	opts = require("plugins.which-key").opts,
	config = require("plugins.which-key").config,
}
