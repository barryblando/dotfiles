return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		enabled = false,
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				hi = {
					background = "CmpPmenu",
				},
				options = {
					show_source = true,
					enable_on_insert = true,
					use_icons_from_diagnostic = false,
					show_all_diags_on_cursorline = true,
				},
			})
		end,
	},
	{
		"rachartier/tiny-glimmer.nvim",
		branch = "main",
		event = "TextYankPost",
		opts = {
			default_animation = "left_to_right",
			overwrite = {
				search = {
					enabled = false,
					default_animation = "pulse",
					next_mapping = "nzzzv",
					prev_mapping = "Nzzzv",
				},
				paste = {
					enabled = true,
					default_animation = "reverse_fade",
					paste_mapping = "p",
					Paste_mapping = "P",
				},
				undo = {
					enabled = true,
					default_animation = {
						name = "fade",
					},
					undo_mapping = "u",
				},
				redo = {
					enabled = true,
					default_animation = {
						name = "reverse_fade",
					},
					redo_mapping = "<c-r>",
				},
			},
		},
	},
}
