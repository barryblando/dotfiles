return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	keys = {
		{ "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha Screen" },
	},
	event = "VimEnter",
	opts = require("plugins.alpha").opts,
	config = require("plugins.alpha").config,
}
