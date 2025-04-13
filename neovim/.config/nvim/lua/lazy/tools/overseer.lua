-- Task runner.
return {
	{
		"stevearc/overseer.nvim",
		init = require("plugins.overseer").init,
		keys = require("plugins.overseer").keys,
		config = require("plugins.overseer").config,
	},
}
