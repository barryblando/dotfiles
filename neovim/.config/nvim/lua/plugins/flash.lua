return {
	"folke/flash.nvim",
	event = "VeryLazy",
	keys = {
		{
			"s",
			mode = { "n", "o", "x" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
	},
	opts = {
		jump = { nohlsearch = true },
		modes = {
			-- Enable flash when searching with ? or /
			search = { enabled = true },
		},
	},
}
