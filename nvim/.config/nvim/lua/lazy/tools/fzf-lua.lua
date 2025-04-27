return {
	"ibhagwan/fzf-lua",
	lazy = false,
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	keys = require("core.keymaps").setup_fzf_lua_keymaps,
	config = require("plugins.fzf-lua").config,
}
