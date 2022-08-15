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
