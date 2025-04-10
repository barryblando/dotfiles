local M = {}

M.config = function()
	local icons = require("utils.icons")

	require("actions-preview").setup({
		-- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
		diff = {
			ctxlen = 3,
		},
		-- priority list of preferred backend
		backend = { "telescope" },

		-- options related to telescope.nvim
		telescope = vim.tbl_extend(
			"force",
			-- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
			require("telescope.themes").get_dropdown({
				-- previewer = false,
				-- even more opts
				borderchars = icons.ui.Border_Chars,
			}),
			-- a table for customizing content
			{
				-- a function to make a table containing the values to be displayed.
				-- fun(action: Action): { title: string, client_name: string|nil }
				make_value = nil,

				-- a function to make a function to be used in `display` of a entry.
				-- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
				-- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
				make_make_display = nil,
			}
		),
	})
end

return M
