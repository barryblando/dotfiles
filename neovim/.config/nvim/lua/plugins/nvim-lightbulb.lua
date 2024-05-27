return {
	"kosayoda/nvim-lightbulb",
	opts = {
		ignore = {
			clients = { "null-ls" },
			ft = { "neo-tree" },
		},
		sign = {
			enabled = true,
			text = "",
			-- Highlight group to highlight the sign column text.
			hl = "LightBulbSign",
		},
		virtual_text = {
			enabled = false,
			-- Text to show in the virt_text.
			text = "",
			-- Position of virtual text given to |nvim_buf_set_extmark|.
			-- Can be a number representing a fixed column (see `virt_text_pos`).
			-- Can be a string representing a position (see `virt_text_win_col`).
			pos = "eol",
			-- Highlight group to highlight the virtual text.
			hl = "LightBulbVirtualText",
			-- How to combine other highlights with text highlight.
			-- See `hl_mode` of |nvim_buf_set_extmark|.
			hl_mode = "combine",
		},
		float = {
			enabled = false,
			-- Text to show in the floating window.
			text = "💡",
			-- Highlight group to highlight the floating window.
			hl = "LightBulbFloatWin",
			-- Window options.
			-- See |vim.lsp.util.open_floating_preview| and |nvim_open_win|.
			-- Note that some options may be overridden by |open_floating_preview|.
			win_opts = {
				focusable = false,
			},
		},
		status_text = {
			enabled = false,
			text = " Code Action Available",
			text_unavailable = "",
		},
		autocmd = {
			-- Whether or not to enable autocmd creation.
			enabled = false,
			-- See |updatetime|.
			-- Set to a negative value to avoid setting the updatetime.
			updatetime = 200,
			-- See |nvim_create_autocmd|.
			events = { "CursorHold", "CursorHoldI" },
			-- See |nvim_create_autocmd| and |autocmd-pattern|.
			pattern = { "*" },
		},
	},
}
