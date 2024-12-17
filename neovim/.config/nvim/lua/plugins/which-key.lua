return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	depedencies = {
		-- Mini Icons alternative to web-devicons
		{ "echasnovski/mini.icons", version = false },
	},
	opts = {
		preset = "helix",
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
		win = {
			no_overlap = true,
			border = require("utils.icons").ui.Border_Single_Line,
			-- padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
			wo = {
				-- winblend = 30,
			},
		},
		-- sort = { "manual" },
		layout = {
			-- height = { min = 4, max = 25 }, -- min and max height of the columns
			-- width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3,
		},
		keys = {
			scroll_down = "<c-d>", -- binding to scroll down inside the popup
			scroll_up = "<c-u>", -- binding to scroll up inside the popup
		},
		show_help = false,
		show_keys = true,
		triggers = {
			{ "<auto>", mode = "nixsotc" },
			{ "m", mode = { "n" } }, -- for harpoon
			{ "g", mode = { "n" } }, -- other lsp mapping
		},
		disable = {
			bt = {},
			ft = {},
		},
	},
	config = function(_, opts)
		local wk = require("which-key")

		wk.setup(opts)

		wk.add({
			{
				"<leader>/",
				'<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
				desc = "Comment",
				nowait = true,
				remap = false,
			},
			{ "<leader>A", "<cmd>ASToggle<cr>", desc = "Toggle Auto-Save", nowait = true, remap = false },
			{
				"<leader>P",
				"<cmd>lua require('telescope').extensions.projects.projects()<cr>",
				desc = "Projects",
				nowait = true,
				remap = false,
			},
			{ "<leader>c", "<cmd>Bdelete!<CR>", desc = "Close Buffer", nowait = true, remap = false },
			{ "<leader>e", "<cmd>Neotree reveal<cr>", desc = "Explorer", nowait = true, remap = false },
			{
				"<leader>q",
				'<cmd>lua require("utils.functions").smart_quit()<CR>',
				desc = "Quit",
				nowait = true,
				remap = false,
			},
			{
				"<leader>/",
				'<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
				desc = "Comment",
				mode = "v",
				nowait = true,
				remap = false,
			},
			{
				"<esc><cmd>'<,'>SnipRun<cr>",
				desc = "Run range",
				mode = "v",
				nowait = true,
				remap = false,
			},
		})

		wk.add({
			{ "<leader>S", group = "Session", nowait = true, remap = false },
			{ "<leader>d", group = "Debug", nowait = true, remap = false },
			{ "<leader>f", group = "Find", nowait = true, remap = false },
			{ "<leader>g", group = "Git", nowait = true, remap = false },
			{ "<leader>l", group = "LSP", nowait = true, remap = false },
			{ "<leader>n", group = "Noice", nowait = true, remap = false },
		})

		-- Options
		wk.add({
			{ "<leader>O", group = "Options", nowait = true, remap = false },
			{
				"<leader>OC",
				"<cmd>lua vim.g.cmp_active=true<cr>",
				desc = "Completion on",
				nowait = true,
				remap = false,
			},
			{
				"<leader>Oc",
				"<cmd>lua vim.g.cmp_active=false<cr>",
				desc = "Completion off",
				nowait = true,
				remap = false,
			},
			{
				"<leader>Ol",
				'<cmd>lua require("utils.functions").toggle_option("cursorline")<cr>',
				desc = "Cursorline",
				nowait = true,
				remap = false,
			},
			{
				"<leader>Or",
				'<cmd>lua require("utils.functions").toggle_option("relativenumber")<cr>',
				desc = "Relative",
				nowait = true,
				remap = false,
			},
			{
				"<leader>Os",
				'<cmd>lua require("utils.functions").toggle_option("spell")<cr>',
				desc = "Spell",
				nowait = true,
				remap = false,
			},
			{
				"<leader>Ow",
				'<cmd>lua require("utils.functions").toggle_option("wrap")<cr>',
				desc = "Wrap",
				nowait = true,
				remap = false,
			},
		})

		-- Overseer
		wk.add({ { "<leader>o", group = "Overseer", nowait = true, remap = false } })

		-- Window Split
		wk.add({
			{ "<leader>s", group = "Split", nowait = true, remap = false },
			{ "<leader>ss", "<cmd>split<cr>", desc = "HSplit", nowait = true, remap = false },
			{ "<leader>sv", "<cmd>vsplit<cr>", desc = "VSplit", nowait = true, remap = false },
		})

		-- Terminal
		wk.add({
			{ "<leader>t", group = "Terminal", nowait = true, remap = false },
		})

		-- Trouble
		wk.add({ { "<leader>x", group = "Trouble", nowait = true, remap = false } })
	end,
}
