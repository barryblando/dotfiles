return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		pcall(require("nvim-treesitter.install").update({ with_sync = true }))
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = require("plugins.treesitter").config,
}
