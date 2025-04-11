return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"bydlw98/blink-cmp-env",
			{
				"onsails/lspkind.nvim",
				opts = {
					symbol_map = { spell = "󰓆 ", cmdline = " ", markdown = " " },
				},
			},

			-- nvim-cmp sources via blink.compat
			"chrisgrieser/cmp_yanky",
		},
		version = "1.*",
		config = require("plugins.blink-cmp").config,
		opts_extend = { "sources.default" },
	},
}
