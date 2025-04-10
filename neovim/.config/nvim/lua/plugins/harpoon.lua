local M = {}

M.config = function()
	local harpoon = require("harpoon")
	local functions = require("core.utils")
	harpoon:setup({})

	vim.keymap.set("n", "<C-e>", function()
		functions.harpoon_ui(harpoon:list())
	end, { desc = "Open Harpoon Window" })

	vim.cmd([[ command! HarpoonUI execute 'lua require("core.utils").harpoon_ui(require("harpoon"):list())' ]])
end

return M
