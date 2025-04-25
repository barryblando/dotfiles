return {
	"ghillb/cybu.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "H", "<Plug>(CybuPrev)", mode = "n" },
		{ "L", "<Plug>(CybuNext)", mode = "n" },
		{ "<s-tab>", "<plug>(CybuLastusedPrev)", mode = "n" },
		{ "<tab>", "<plug>(CybuLastusedNext)", mode = "n" },
	},
	config = require("plugins.cybu").config,
}
