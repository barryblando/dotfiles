return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-media-files.nvim",
		-- "nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	lazy = true,
	keys = require("core.keymaps").setup_telescope_keymaps(),
	config = require("plugins.telescope").config,
}
