return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	event = "VimEnter",
	opts = require("plugins.alpha").opts,
	config = require("plugins.alpha").config,
}
