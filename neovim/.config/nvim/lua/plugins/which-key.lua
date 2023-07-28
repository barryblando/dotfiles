return {
	"folke/which-key.nvim",
	config = function()
		local status_ok, which_key = pcall(require, "which-key")
		if not status_ok then
			return
		end

		local icons = require("utils.icons")

		local setup = {
			plugins = {
				marks = false, -- shows a list of your marks on ' and `
				registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
					motions = true, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},
			-- add operators that will trigger motion and text object completion
			-- to enable all native operators, set the preset / operators plugin above
			-- operators = { gc = "Comments" },
			key_labels = {
				-- override the label used to display some keys. It doesn't effect WK in any other way.
				-- For example:
				-- ["<space>"] = "SPC",
				-- ["<cr>"] = "RET",
				-- ["<tab>"] = "TAB",
			},
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},
			popup_mappings = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
			window = {
				border = icons.ui.Border_Single_Line,
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},
			ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
			show_help = true, -- show help message on the command line when the popup is visible
			triggers = "auto", -- automatically setup triggers
			-- triggers = {"<leader>"} -- or specify a list manually
			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				-- this is mostly relevant for key maps that start with a native binding
				-- most people should not need to change this
				i = { "j", "k" },
				v = { "j", "k" },
			},
		}

		local opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}

		local m_opts = {
			mode = "n", -- NORMAL mode
			prefix = "m",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}

		local m_mappings = {
			m = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
			["."] = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "Harpoon Next" },
			[","] = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "Harpoon Prev" },
			s = { "<cmd>Telescope harpoon marks<cr>", "Search Files" },
			[";"] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
		}

		local mappings = {
			["a"] = { "<cmd>Alpha<cr>", "Alpha" },
			["A"] = { "<cmd>ASToggle<cr>", "Toggle Auto-Save" },
			["e"] = { "<cmd>Neotree reveal<cr>", "Explorer" },
			["w"] = { "<cmd>w!<CR>", "Save" },
			["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
			["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
			["q"] = { '<cmd>lua require("utils.functions").smart_quit()<CR>', "Quit" },
			["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
			["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
			-- ["x"] = { "<cmd>!chmod +x %<cr>", "Make Script Executable" },

			p = {
				name = "Lazy Plugin Manager",
				C = { "<cmd>Lazy clean<cr>", "Clean [plugins]" },
				c = { "<cmd>Lazy check<cr>", "Check [plugins]" },
				d = { "<cmd>Lazy debug<cr>", "Debug" },
				h = { "<cmd>Lazy health<cr>", "Health" },
				p = { "<cmd>Lazy profile<cr>", "Profile" },
				s = { "<cmd>Lazy sync<cr>", "Sync" },
				u = { "<cmd>Lazy update<cr>", "Update" },
			},

			o = {
				name = "Options",
				c = { "<cmd>lua vim.g.cmp_active=false<cr>", "Completion off" },
				C = { "<cmd>lua vim.g.cmp_active=true<cr>", "Completion on" },
				w = { '<cmd>lua require("utils.functions").toggle_option("wrap")<cr>', "Wrap" },
				r = { '<cmd>lua require("utils.functions").toggle_option("relativenumber")<cr>', "Relative" },
				l = { '<cmd>lua require("utils.functions").toggle_option("cursorline")<cr>', "Cursorline" },
				s = { '<cmd>lua require("utils.functions").toggle_option("spell")<cr>', "Spell" },
			},

			s = {
				name = "Split",
				s = { "<cmd>split<cr>", "HSplit" },
				v = { "<cmd>vsplit<cr>", "VSplit" },
			},

			S = {
				name = "Session",
				s = { "<cmd>SessionSave<cr>", "Save" },
				r = { "<cmd>SessionRestore<cr>", "Restore" },
				x = { "<cmd>SessionDelete<cr>", "Delete" },
				-- f = { "<cmd>Telescope session-lens search_session<cr>", "Find" },
				f = { '<cmd>lua require("auto-session.session-lens").search_session()<cr>', "Find" },
				d = { "<cmd>Autosession delete<cr>", "Find Delete" },
			},

			d = {
				name = "Debug",
				b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
				c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
				i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
				o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
				O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
				r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
				l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
				u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
				x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
			},

			f = {
				name = "Find",
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
				f = { "<cmd>Telescope find_files<cr>", "Find files" },
				t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
				s = { "<cmd>Telescope grep_string<cr>", "Find String" },
				h = { "<cmd>Telescope help_tags<cr>", "Help" },
				H = { "<cmd>Telescope highlights<cr>", "Highlights" },
				i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
				l = { "<cmd>Telescope resume<cr>", "Last Search" },
				M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
				R = { "<cmd>Telescope registers<cr>", "Registers" },
				k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
				C = { "<cmd>Telescope commands<cr>", "Commands" },
			},

			g = {
				name = "Git",
				g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
				j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				u = {
					"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
					"Undo Stage Hunk",
				},
				o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				d = {
					"<cmd>Gitsigns diffthis HEAD<cr>",
					"Diff",
				},
			},

			l = {
				name = "LSP",
				a = { "<cmd>CodeActionMenu<cr>", "Code Action" },
				--[[ c = { "<cmd>lua require('lsp').server_capabilities()<cr>", "Get Capabilities" }, ]]
				d = {
					"<cmd>Telescope diagnostics bufnr=0<cr>",
					"Document Diagnostics",
				},
				w = {
					"<cmd>Telescope diagnostics<cr>",
					"Workspace Diagnostics",
				},
				f = { "<cmd>lua vim.lsp.buf.format({ async = false })<cr>", "Format" },
				F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
				h = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
				i = { "<cmd>LspInfo<cr>", "Info" },
				j = {
					"<cmd>lua vim.lsp.diagnostic.goto_next({buffer=0})<CR>",
					"Next Diagnostic",
				},
				k = {
					"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
					"Prev Diagnostic",
				},
				v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Virtual Lines" },
				l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
				q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
				r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
				-- R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				S = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
			},

			t = {
				name = "Terminal",
				["1"] = { ":1ToggleTerm<cr>", "1" },
				["2"] = { ":2ToggleTerm<cr>", "2" },
				["3"] = { ":3ToggleTerm<cr>", "3" },
				["4"] = { ":4ToggleTerm<cr>", "4" },
				n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
				d = { "<cmd>lua _LAZYDOCKER_TOGGLE()<cr>", "Docker" },
				g = { "<cmd>lua _GDU_TOGGLE()<cr>", "GDU" },
				b = { "<cmd>lua _BTOP_TOGGLE()<cr>", "Btop" },
				p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
				f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
				h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
				v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
			},
		}

		local vopts = {
			mode = "v", -- VISUAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}

		local vmappings = {
			["/"] = { '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', "Comment" },
			s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
		}

		-- vim.o.timeout = true
		-- vim.o.timeoutlen = 300

		which_key.setup(setup)
		which_key.register(mappings, opts)
		which_key.register(m_mappings, m_opts)
		which_key.register(vmappings, vopts)
	end,
}
