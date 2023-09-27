return {
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

	-- Better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
		config = function()
			local icons = require("utils.icons")

			require("dressing").setup({
				input = {
					border = icons.ui.Border_Single_Line,
					win_options = {
						winblend = 0,
					},
				},
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

	-- Noicer ui
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			local icons = require("utils.icons")

			require("noice").setup({
				views = {
					cmdline_popup = {
						border = {
							style = icons.ui.Border_Single_Line,
							-- padding = { 1, 1 },
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
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc =
        "Redirect Cmdline"
      },
      { "<leader>snl", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,     desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
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

	-- Colorizer
	{ "NvChad/nvim-colorizer.lua", config = true },
}
