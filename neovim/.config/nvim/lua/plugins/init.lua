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

	-- Closing buffers
	"famiu/bufdelete.nvim",

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
	-- AUTO COMPLETION --
	---------------------

	{
		"hrsh7th/nvim-cmp", -- The completion plugin
		dependencies = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim's built-in language server client
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			-- snippet engine, requires cmp_luasnip in order to work
			{
				"L3MON4D3/LuaSnip",
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
			},
			"rafamadriz/friendly-snippets", -- a bunch of snippets to use
			{
				"roobert/tailwindcss-colorizer-cmp.nvim",
				ft = { "html", "javascriptreact", "typescriptreact", "svelte", "vue", "markdown" },
				-- optionally, override the default options:
				config = function()
					require("tailwindcss-colorizer-cmp").setup({
						color_square_width = 2,
					})
				end,
			},
		},
	},

	{
		"github/copilot.vim",
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
			-- INFO: null-ls will be archive on Aug 11, 2023, https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1621
			-- NOTE: alternative: https://github.com/stevearc/conform.nvim & https://github.com/mfussenegger/nvim-lint
			"nvimtools/none-ls.nvim", -- for formatters and linters
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
