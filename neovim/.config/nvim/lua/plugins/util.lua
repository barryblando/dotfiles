return {
	-- Session management. This saves your session in the background,
	-- keeping track of open buffers, window arrangement, and more.
	-- You can restore sessions when returning through the dashboard.
	{
		"rmagatti/auto-session",
		lazy = true,
		keys = {
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
		},
		init = function()
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
		end,
		config = function()
			local status_ok, auto_session = pcall(require, "auto-session")
			if not status_ok then
				return
			end

			local icons = require("utils.icons")

			local opts = {
				log_level = "info",
				auto_session_enable_last_session = false,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_save_enabled = nil,
				auto_session_pre_save_cmds = { "tabdo NeoTreeClose" },
				auto_restore_enabled = nil,
				auto_session_suppress_dirs = { os.getenv("HOME") },
				auto_session_use_git_branch = nil,
				-- the configs below are lua onlqy
				bypass_session_save_file_types = { "alpha" },
				session_lens = {
					path_display = { "shorten" },
					theme_conf = {
						borderchars = icons.ui.Border_Chars,
						winblend = 0,
					},
					previewer = false,
					prompt_title = "Sessions",
				},
			}

			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

			auto_session.setup(opts)
		end,
	},

	-- An implementation of the Popup API from vim in Neovim
	"nvim-lua/popup.nvim",

	-- Useful lua functions used by lots of plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}
