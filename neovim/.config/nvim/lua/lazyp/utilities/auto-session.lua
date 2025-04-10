return {
	-- Session management. This saves your session in the background,
	-- keeping track of open buffers, window arrangement, and more.
	-- You can restore sessions when returning through the dashboard.
	{
		"rmagatti/auto-session",
		lazy = true,
		keys = require("plugins.auto-session").keys,
		init = require("plugins.auto-session").init,
		config = require("plugins.auto-session").config,
	},
}
