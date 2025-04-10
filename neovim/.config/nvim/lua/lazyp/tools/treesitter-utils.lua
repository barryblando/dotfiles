return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	"HiPhish/rainbow-delimiters.nvim",
	"windwp/nvim-ts-autotag",

	-- Treesitter text dimming
	{
		"folke/twilight.nvim",
		cmd = { "Twilight" },
		keys = {
			{ "<C-z>", "<cmd>Twilight<cr>", desc = "Dim Surroundings" },
		},
		-- setup = function()
		-- 	vim.keymap.set("n", "<C-z>", "<Cmd>Twilight<CR>", { desc = "dim inactive surroundings" })
		-- end,
		config = function()
			require("twilight").setup()
			-- TEMP: transparent background issue #15
			local tw_config = require("twilight.config")
			local tw_colors = tw_config.colors
			tw_config.colors = function(...)
				tw_colors(...)
				vim.cmd("hi! Twilight guibg=NONE")
			end
		end,
	},
}
