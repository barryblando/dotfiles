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

M.init = function()
	-- LAZY AUTOSESSION
	local autocmd = vim.api.nvim_create_autocmd
	local lazy_did_show_install_view = false

	local function auto_session_restore()
		-- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
		vim.schedule(function()
			require("auto-session").AutoRestoreSession()
		end)
	end

	autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			local lazy_view = require("lazy.view")

			if lazy_view.visible() then
				-- if lazy view is visible do nothing with auto-session
				lazy_did_show_install_view = true
			else
				-- otherwise load (by require'ing) and restore session
				auto_session_restore()
			end
		end,
	})

	autocmd("WinClosed", {
		pattern = "*",
		callback = function(ev)
			local lazy_view = require("lazy.view")

			-- if lazy view is currently visible and was shown at startup
			if lazy_view.visible() and lazy_did_show_install_view then
				-- if the window to be closed is actually the lazy view window
				if ev.match == tostring(lazy_view.view.win) then
					lazy_did_show_install_view = false
					auto_session_restore()
				end
			end
		end,
	})
end

M.config = function()
	local status_ok, auto_session = pcall(require, "auto-session")
	if not status_ok then
		return
	end

	local icons = require("utils.icons")

	local opts = {
		auto_restore_last_session = false,
		auto_session_pre_save_cmds = { "tabdo NeoTreeClose" },
		bypass_save_filetypes = { "alpha" },
		enabled = true,
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
