local M = {}

M.opts = function()
	local icons = require("core.icons")
	local opts = {
		default_file_explorer = true,
		use_default_keymaps = false,
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git"
			end,
		},
		win_options = {
			wrap = true,
		},
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
	}

	opts["keymaps"] = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
		["<C-h>"] = {
			"actions.select",
			opts = { horizontal = true },
			desc = "Open the entry in a horizontal split",
		},
		-- ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
		["<C-t>"] = '<cmd>lua require("oil").select({close=false, tab=true}, function() require("oil").open_float() end)<cr>',
		["<C-p>"] = "actions.preview",
		["<esc>"] = "actions.close",
		["q"] = "actions.close",
		["<C-l>"] = "actions.refresh",
		["<BS>"] = "actions.parent",
		-- ["-"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	}

	opts["float"] = {
		-- padding = 5,
		max_width = 100,
		max_height = 40,
		border = icons.ui.Border_Single_Line,
		preview_split = "below",
	}

	opts["preview"] = {
		border = icons.ui.Border_Single_Line,
	}

	opts["progress"] = {
		border = icons.ui.Border_Single_Line,
	}

	opts["keymaps_help"] = {
		border = icons.ui.Border_Single_Line,
	}

	return opts
end

return M
