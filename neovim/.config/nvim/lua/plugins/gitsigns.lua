local M = {}

M.config = function()
	local icons = require("utils.icons")

	-- local gs = package.loaded.gitsigns

	require("gitsigns").setup({
		signs = {
			add = {
				text = icons.gitsigns.GitSignsAdd,
			},
			change = {
				text = icons.gitsigns.GitSignsChange,
			},
			delete = {
				text = icons.gitsigns.GitSignsDelete,
			},
			topdelete = {
				text = icons.gitsigns.GitSignsTopDelete,
			},
			changedelete = {
				text = icons.gitsigns.GitSignsChangeDelete,
			},
			untracked = {
				text = icons.gitsigns.GitSignsUntracked,
			},
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = true,
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
			ignore_whitespace = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		-- current_line_blame_formatter_opts = {
		-- 	relative_time = false,
		-- },
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000,
		preview_config = {
			-- Options passed to nvim_open_win
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
end

return M
