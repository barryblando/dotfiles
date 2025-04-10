-- Task runner.
return {
	{
		"stevearc/overseer.nvim",
		opts = require("plugins.overseer").opts,
		keys = require("plugins.overseer").keys,
	},
}
