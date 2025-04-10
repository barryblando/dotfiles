local M = {}

M.keys = function()
	local Snacks = require("snacks")
	return {
		{
			"<leader>c",
			function()
				Snacks.bufdelete()
			end,
			desc = "Buffer Delete",
			mode = "n",
		},
		{
			"<leader>ba",
			function()
				Snacks.bufdelete.all()
			end,
			desc = "Buffer Delete All",
			mode = "n",
		},
		{
			"<leader>bo",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Buffer Delete Other",
			mode = "n",
		},
	}
end

M.config = function()
	local icons = require("utils.icons")
	require("snacks").setup({
		input = {
			enabled = true,
			backdrop = false,
			position = "float",
			border = icons.ui.Border_Chars_Single_Line,
			title_pos = "center",
			height = 1,
			width = 60,
			relative = "editor",
			noautocmd = true,
			row = 2,
			-- relative = "cursor",
			-- row = -3,
			-- col = 0,
			wo = {
				winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
				cursorline = false,
			},
			bo = {
				filetype = "snacks_input",
				buftype = "prompt",
			},
			--- buffer local variables
			b = {
				completion = false, -- disable blink completions in input
			},
			keys = {
				n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
				i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
				i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
				i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
				i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
				i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
				i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
				q = "cancel",
			},
		},
	})
end

return M
