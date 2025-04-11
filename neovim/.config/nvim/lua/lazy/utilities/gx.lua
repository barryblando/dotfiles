return {
	"chrishrb/gx.nvim",
	keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
	cmd = { "Browse" },
	init = function()
		vim.g.netrw_nogx = 1
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local opts = {
			-- using wsl2
			open_browser_app = "wslview",
		}

		return opts
	end,
	config = function(_, opts)
		require("gx").setup(opts)
	end,
	submodules = false, -- not needed, submodules are required only for tests
}
