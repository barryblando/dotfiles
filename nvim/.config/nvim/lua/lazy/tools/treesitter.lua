return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	-- build = function()
	-- 	pcall(require("nvim-treesitter.install").update({ with_sync = true }))
	-- end,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	init = require("plugins.treesitter").init,
	config = require("plugins.treesitter").config,
}
