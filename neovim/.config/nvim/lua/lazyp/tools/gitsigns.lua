return {
	"lewis6991/gitsigns.nvim",
	keys = require("core.keymaps").setup_gitsigns_keymaps(),
	config = require("plugins.gitsigns").config,
}
