return {
	"stevearc/dressing.nvim",
	lazy = true,
	init = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
	end,
	config = function()
		local icons = require("utils.icons")
		require("dressing").setup({
			select = {
				telescope = require("telescope.themes").get_dropdown({ -- or 'cursor'
					borderchars = icons.ui.Border_Chars,
					-- layout_config = {
					--   height = function(self, _, max_lines)
					--     return random_height_i_computed
					--   end,
					-- },
				}),
				builtin = {
					border = icons.ui.Border_Chars_Single_Line,
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
			},
		})
	end,
}
