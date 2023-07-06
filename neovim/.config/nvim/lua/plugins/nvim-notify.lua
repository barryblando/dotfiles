return {
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
}
