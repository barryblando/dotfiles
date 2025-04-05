return {
	---------------------
	--  COLOR SCHEMES  --
	---------------------

	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		init = function()
			-- load the colorscheme here
			vim.cmd([[
        " Important!! https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt
        " if has('termguicolors')
        " set termguicolors
        " endif

        " For dark version.
        set background=dark

        " This configuration option should be placed before `colorscheme gruvbox-material`.
        " Available values: 'hard', 'medium'(default), 'soft'
        let g:gruvbox_material_background = 'hard'

        let g:gruvbox_material_foreground = 'mix'

        let g:gruvbox_material_transparent_background = 1

        " For better performance
        let g:gruvbox_material_better_performance = 1

        let g:gruvbox_material_enable_italic = 1

        colorscheme gruvbox-material
      ]])
		end,
	},

	---------------------
	-- Setup Utilities --
	---------------------

	-- auto-save, default config used
	{
		"Pocco81/auto-save.nvim",
		cmd = "ASToggle",
		event = { "InsertLeave" },
		-- event = { "InsertLeave", "TextChanged" },
	},

	-- For jumping cursor in every word
	-- "unblevable/quick-scope",

	-- Multiple Select Cursor
	{ "mg979/vim-visual-multi", branch = "master" },

	-- Tracking Code stats
	{ "wakatime/vim-wakatime" },

	-- Markdown Previewer
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	---------------------
	--- AI COMPLETION ---
	---------------------

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		enabled = false,
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	---------------------
	--      LSP        --
	---------------------

	{
		"neovim/nvim-lspconfig", -- enable LSP
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim", -- providing access to the SchemaStore catalog.

			{
				"j-hui/fidget.nvim",
				-- enabled = false,
				opts = {
					progress = {
						display = {
							done_icon = "",
						},
					},
					notification = {
						window = {
							winblend = 0, -- &winblend for the window
						},
					},
				},
			},
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Library paths can be absolute
				-- "~/projects/my-awesome-lib",

				-- Or relative, which means they will be resolved from the plugin dir.
				"luvit-meta/library",
				"neotest",
				"plenary",
				"nvim-dap-ui",

				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },

				-- Load the wezterm types when the `wezterm` module is required
				-- Needs `justinsgithub/wezterm-types` to be installed
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},

	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

	{ "WhoIsSethDaniel/lualine-lsp-progress.nvim", enabled = false },

	-- LSP signature help
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			local icons = require("utils.icons")

			local cfg = {
				-- general options
				always_trigger = false,
				hint_enable = false, -- virtual text hint
				bind = true,
				max_width = 80,

				-- floating window

				padding = " ",
				auto_close_after = 200,
				transparency = nil,
				floating_window_above_cur_line = true,
				handler_opts = {
					border = icons.ui.Border_Single_Line,
				},
				toggle_key = "<C-k>",
				toggle_key_flip_floatwin_setting = true,
			}

			require("lsp_signature").setup(cfg)
		end,
	},

	---------------------
	--   TREESITTER    --
	---------------------

	"JoosepAlviste/nvim-ts-context-commentstring",
	"HiPhish/rainbow-delimiters.nvim",
	"windwp/nvim-ts-autotag",

	-- Treesitter text dimming
	{
		"folke/twilight.nvim",
		cmd = { "Twilight" },
		keys = {
			{ "<C-z>", "<cmd>Twilight<cr>", desc = "Dim Surroundings" },
		},
		-- setup = function()
		-- 	vim.keymap.set("n", "<C-z>", "<Cmd>Twilight<CR>", { desc = "dim inactive surroundings" })
		-- end,
		config = function()
			require("twilight").setup()
			-- TEMP: transparent background issue #15
			local tw_config = require("twilight.config")
			local tw_colors = tw_config.colors
			tw_config.colors = function(...)
				tw_colors(...)
				vim.cmd("hi! Twilight guibg=NONE")
			end
		end,
	},

	---------------------
	--      GIT        --
	---------------------
	{
		"akinsho/git-conflict.nvim",
		version = "1.0.0",
		config = true,
	},

	---------------------
	--   EXPIREMENT    --
	---------------------

	-- Plugins to Experiment in spare time
	-- https://github.com/axieax/dotconfig/blob/main/nvim/lua/axie/plugins/init.lua
	-- https://github.com/chrisgrieser/nvim-scissors
	-- use "ThePrimeagen/refactoring.nvim"
	-- use { "NTBBloodbath/rest.nvim" }
	-- use { "junegunn/vim-easy-align" }
	-- use { "kevinhwang91/nvim-bqf", ft = "qf" }
	-- https://github.com/is0n/jaq-nvim
}
