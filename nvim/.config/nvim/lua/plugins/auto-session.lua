local M = {}

M.keys = {
	{ "<leader>Sd", "<cmd>Autosession delete<cr>", desc = "Find Delete", nowait = true, remap = false },
	{
		"<leader>Sf",
		'<cmd>lua require("auto-session.session-lens").search_session()<cr>',
		desc = "Find",
		nowait = true,
		remap = false,
	},
	{ "<leader>Sr", "<cmd>SessionRestore<cr>", desc = "Restore", nowait = true, remap = false },
	{ "<leader>Ss", "<cmd>SessionSave<cr>", desc = "Save", nowait = true, remap = false },
	{ "<leader>Sx", "<cmd>SessionDelete<cr>", desc = "Delete", nowait = true, remap = false },
}

M.config = function()
	local status_ok, auto_session = pcall(require, "auto-session")
	if not status_ok then
		return
	end

	local icons = require("utils.icons")

	local opts = {
		enabled = true,
		auto_restore = true,
		-- auto_restore_last_session = false,
		lazy_support = true,
		pre_save_cmds = { "tabdo Neotree close" },
		lsp_stop_on_restore = true,
		bypass_save_filetypes = { "alpha", "neo-tree", "TelescopePrompt", "lazy", "OverseerList" },
		log_level = "info",
		root_dir = vim.fn.stdpath("data") .. "/sessions/",
		session_lens = {
			path_display = { "shorten" },
			previewer = false,
			prompt_title = "Sessions",
			theme_conf = {
				borderchars = icons.ui.Border_Chars,
				winblend = 0,
			},
		},
		suppressed_dirs = { os.getenv("HOME") },
	}

	vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

	auto_session.setup(opts)
end

return M
