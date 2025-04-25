return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"stevearc/overseer.nvim",
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
			"marilari88/neotest-vitest",
			"rcarriga/nvim-notify",
			"andythigpen/nvim-coverage",
			-- "nvim-neotest/nvim-nio",
		},
		init = require("plugins.testing").init,
		keys = require("plugins.testing").keys,
		config = require("plugins.testing").config,
	},
}
