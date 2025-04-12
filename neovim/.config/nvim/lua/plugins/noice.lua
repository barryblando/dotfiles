local M = {}

M.config = function()
	local icons = require("core.icons")

	require("noice").setup({
		cmdline = {
			format = {
				cmdline = { title = "" },
				search_down = { title = "" },
				search_up = { title = "" },
				filter = { title = "" },
				lua = { title = "" },
				help = { title = "" },
				input = { title = "" },
			},
		},
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
			inc_rename = false,
		},
	})
end

M.keys = {
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
}

return M
