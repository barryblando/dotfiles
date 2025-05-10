return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	init = function()
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false

		vim.cmd([[ command! LspToggleAutoFormat execute 'lua require("core.utils").toggle_format_on_save()' ]])
	end,
	config = require("plugins.conform").config,
}
