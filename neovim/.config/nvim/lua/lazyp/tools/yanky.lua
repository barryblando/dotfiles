return {
	-- Clipboard
	"gbprod/yanky.nvim",
	dependencies = {
		{ "kkharji/sqlite.lua" },
	},
	opts = {
		ring = { storage = "sqlite" },
	},
	keys = require("core.keymaps").setup_yanky_keymaps(),
}
