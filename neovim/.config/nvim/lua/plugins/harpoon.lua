-- plugin to specify, or on the fly, mark and create persisting key strokes to go to the files you want.
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		local functions = require("utils.functions")
		harpoon:setup({})

		vim.keymap.set("n", "<C-e>", function()
			functions.harpoon_ui(harpoon:list())
		end, { desc = "Open Harpoon Window" })

		vim.cmd([[ command! HarpoonUI execute 'lua require("utils.functions").harpoon_ui(require("harpoon"):list())' ]])
	end,
}
