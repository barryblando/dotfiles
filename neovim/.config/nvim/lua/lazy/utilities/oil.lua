return {
	"stevearc/oil.nvim",
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	keys = {
		{ "<leader>-", "<cmd>Oil --float<cr>", desc = "Explorer", nowait = true, remap = false },
	},
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	opts = require("plugins.oil").opts,
	config = function(_, opts)
		require("oil").setup(opts)
	end,
}
