-- plugin to specify, or on the fly, mark and create persisting key strokes to go to the files you want.
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = require("core.keymaps").setup_harpoon_keymaps(),
	config = require("plugins.harpoon").config,
}
