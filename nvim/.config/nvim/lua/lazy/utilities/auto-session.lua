return {
	-- Session management. This saves your session in the background,
	-- keeping track of open buffers, window arrangement, and more.
	-- You can restore sessions when returning through the dashboard.
	{
		"rmagatti/auto-session",
		lazy = false,
		keys = require("plugins.auto-session").keys,
		config = require("plugins.auto-session").config,
	},
}
