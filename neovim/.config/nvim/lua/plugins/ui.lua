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
	-- Better `vim.notify()`
	{
		"rcarriga/nvim-notify",
		config = function()
			local status_ok, notify = pcall(require, "notify")

			if not status_ok then
				return
			end

			local icons = require("utils.icons")

			notify.setup({
				-- Animation style (see below for details)
				stages = "fade",
				-- Function called when a new window is opened, use for changing win settings/config
				on_open = function(win)
					vim.api.nvim_win_set_option(win, "wrap", true)
					vim.api.nvim_win_set_config(win, { zindex = 20000 })
					vim.api.nvim_win_set_config(win, { border = icons.ui.Border_Single_Line })
					vim.api.nvim_win_set_option(win, "winhighlight", "Normal:NormalFloat")
				end,

				-- Function called when a window is closed
				---@diagnostic disable-next-line: assign-type-mismatch
				on_close = nil,

				-- Render function for notifications. See notify-render()
				render = "default",

				-- Default timeout for notifications
				timeout = 175,

				-- For stages that change opacity this is treated as the highlight behind the window
				-- Set this to either a highlight group or an RGB hex value e.g. "#000000"
				background_colour = "#000000",

				-- Minimum width for notification windows
				minimum_width = 40,

				-- Icons for the different levels
				icons = {
					ERROR = icons.diagnostics.Error,
					WARN = icons.diagnostics.Warning,
					INFO = icons.diagnostics.Information,
					DEBUG = icons.ui.Bug,
					TRACE = icons.ui.Pencil,
				},
			})

			vim.notify = notify
		end,
	},

	-- Better vim.ui.select
	{
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
	},

	{
		"folke/snacks.nvim",
		config = function()
			local icons = require("utils.icons")
			require("snacks").setup({
				input = {
					backdrop = false,
					position = "float",
					border = icons.ui.Border_Single_Line,
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
		end,
	},

	-- Noicer ui
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			local icons = require("utils.icons")

			require("noice").setup({
				-- Hide written messages
				routes = {
					{
						filter = {
							event = "msg_show",
							kind = "",
						},
						opts = { skip = true },
					},
				},
				views = {
					cmdline_popup = {
						border = {
							style = icons.ui.Border_Single_Line,
							-- padding = { 1, 1 },
						},
						position = {
							row = 5,
							col = "50%",
						},
						filter_options = {},
						win_options = {
							winhighlight = {
								Normal = "NormalFloat",
								FloatBorder = "FloatBorder",
							},
						},
					},
					cmdline_popupmenu = {
						position = {
							row = 8,
							col = "50%",
						},
						view = "popupmenu",
						zindex = 200,
						border = {
							style = icons.ui.Border_Single_Line,
							-- padding = { 1, 1 },
						},
					},
					popupmenu = {
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "FloatBorder" },
						},
					},
					popup = {
						border = {
							style = icons.ui.Border_Single_Line,
						},
						win_options = {
							winhighlight = {
								Normal = "NormalFloat",
								FloatBorder = "FloatBorder",
							},
						},
					},
				},
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = false,
					},
					progress = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
				},
				presets = {
					bottom_search = false,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
				},
			})
		end,
		keys = {
			-- stylua: ignore start
			{
				"<S-Enter>",
				function()
					require("noice").redirect(vim.fn.getcmdline())
				end,
				mode = "c",
				desc = "Redirect Cmdline",
			},
			{
				"<leader>nl",
				function()
					require("noice").cmd("last")
				end,
				desc = "Noice Last Message",
			},
			{
				"<leader>nh",
				function()
					require("noice").cmd("history")
				end,
				desc = "Noice History",
			},
			{
				"<leader>na",
				function()
					require("noice").cmd("all")
				end,
				desc = "Noice All",
			},
			{
				"<leader>nd",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = "Dismiss All",
			},
			-- stylua: ignore end
			{
				"<c-f>",
				function()
					if not require("noice.lsp").scroll(4) then
						return "<c-f>"
					end
				end,
				silent = true,
				expr = true,
				desc = "Scroll forward",
				mode = { "i", "n", "s" },
			},
			{
				"<c-b>",
				function()
					if not require("noice.lsp").scroll(-4) then
						return "<c-b>"
					end
				end,
				silent = true,
				expr = true,
				desc = "Scroll backward",
				mode = { "i", "n", "s" },
			},
		},
	},

	-- UI Component Library for Neovim
	{ "MunifTanjim/nui.nvim", lazy = true },
}
