return {
	"kylechui/nvim-surround",
	-- enabled = false,
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		local status_ok, surround = pcall(require, "nvim-surround")
		if not status_ok then
			return
		end

		-- https://vimhelp.org/motion.txt.html#object-select
		surround.setup({
			keymaps = {
				insert = "ys",
				insert_line = "yss",
				visual = "S",
				delete = "ds",
				change = "cs",
			},
			-- surrounds = {}, -- Gotta use the default config, https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
			highlight = { -- Highlight before inserting/changing surrounds
				duration = 0,
			},
		})
	end,
}
