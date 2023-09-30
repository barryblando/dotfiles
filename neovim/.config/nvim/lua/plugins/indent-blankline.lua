return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "│",
			tab_char = "┆",
		},
		scope = {
			include = {
				node_type = {
					lua = {
						"chunk",
						"do_statement",
						"while_statement",
						"repeat_statement",
						"if_statement",
						"for_statement",
						"function_declaration",
						"function_definition",
						"table_constructor",
						"assignment_statement",
					},
					go = {
						"if_statement",
						"function_declaration",
						"function_definition",
						"method_definition",
						"for_statement",
						"block",
						"interface_type",
						"struct_type",
						"select_statement",
						"communication_case",
						"composite_literal",
					},
					typescript = {
						"statement_block",
						"function",
						"arrow_function",
						"function_declaration",
						"method_definition",
						"for_statement",
						"for_in_statement",
						"catch_clause",
						"object_pattern",
						"arguments",
						"switch_case",
						"switch_statement",
						"switch_default",
						"object",
						"object_type",
						"ternary_expression",
					},
				},
			},
		},
		exclude = {
			filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
			buftypes = { "terminal", "nofile" },
		},
	},
	config = function(_, opts)
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		local hooks = require("ibl.hooks")

		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#FB4934" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#FABD2F" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#83A598" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FE8019" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#B8BB26" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#D3869B" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#8EC07C" })
		end)

		vim.g.rainbow_delimiters = { highlight = highlight }

		require("ibl").setup({
			scope = {
				highlight = highlight,
				char = opts.indent.char,
				include = opts.scope.include,
			},
			indent = {
				char = opts.indent.tab_char,
				tab_char = opts.indent.tab_char,
			},
			whitespace = {
				remove_blankline_trail = true,
			},
		})

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
	end,
}
