return {
	"kylechui/nvim-surround",
	-- enabled = false,
	version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	opts = {
		-- https://vimhelp.org/motion.txt.html#object-select
		keymaps = {
			visual = "S",
			delete = "ds",
			change = "cs",
		},
		-- surrounds = {}, -- Gotta use the default config, https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
		highlight = { -- Highlight before inserting/changing surrounds
			duration = 0,
		},
	},
}
