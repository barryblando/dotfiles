return {
	"akinsho/toggleterm.nvim",
	init = require("plugins.toggleterm").init,
	keys = require("core.keymaps").setup_toggleterm_keymaps(),
	config = require("plugins.toggleterm").config,
}
