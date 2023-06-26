-- local function tabnine_build_path()
-- 	if vim.loop.os_uname().sysname == "Windows_NT" then
-- 		return "pwsh.exe -file .\\dl_binaries.ps1"
-- 	else
-- 		return "./dl_binaries.sh"
-- 	end
-- end

return {

	---------------------
	--  COLOR SCHEMES  --
	---------------------

	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
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

	-- An implementation of the Popup API from vim in Neovim
	"nvim-lua/popup.nvim",

	-- Useful lua functions used by lots of plugins
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- UI Component Library for Neovim
	{ "MunifTanjim/nui.nvim", lazy = true },

	-- Closing buffers
	"famiu/bufdelete.nvim",

	-- Remove mapping escape delay
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				mapping = { "jk", "kj" },
			})
		end,
	},

	-- auto-save, default config used
	{
		"Pocco81/auto-save.nvim",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
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

	-- plugin to specify, or on the fly, mark and create persisting key strokes to go to the files you want.
	{ "ThePrimeagen/harpoon", lazy = true },

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
			"L3MON4D3/LuaSnip", -- snippet engine, requires cmp_luasnip in order to work
			"rafamadriz/friendly-snippets", -- a bunch of snippets to use
		},
	},

	--  {
	--    "codota/tabnine-nvim",
	--    build = tabnine_build_path(),
	--    opts = {
	--      disable_auto_comment=true,
	--      accept_keymap="<Tab>",
	--      dismiss_keymap = "<C-]>",
	--      debounce_ms = 800,
	--      suggestion_color = {gui = "#808080", cterm = 244},
	--      exclude_filetypes = {"TelescopePrompt"},
	--      log_file_path = nil, -- absolute path to Tabnine log file
	--    }
	--  },

	-- {
	-- 	"tzachar/cmp-tabnine",
	-- 	build = "./install.sh",
	-- 	dependencies = "hrsh7th/nvim-cmp",
	-- 	config = function()
	-- 		local status_ok, tabnine = pcall(require, "cmp_tabnine.config")

	-- 		if not status_ok then
	-- 			return
	-- 		end

	-- 		tabnine:setup({
	-- 			max_lines = 1000,
	-- 			max_num_results = 20,
	-- 			sort = true,
	-- 			run_on_every_keystroke = true,
	-- 			snippet_placeholder = "..",
	-- 			ignored_file_types = { -- default is not to ignore
	-- 				-- uncomment to ignore in lua:
	-- 				-- lua = true
	-- 			},
	-- 		})
	-- 	end,
	-- },

	---------------------
	--      LSP        --
	---------------------

	{
		"neovim/nvim-lspconfig", -- enable LSP
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
			"folke/neodev.nvim", -- full signature help, docs and completion for the nvim lua API
			"b0o/schemastore.nvim", -- providing access to the SchemaStore catalog.

			{
				"j-hui/fidget.nvim",
				-- NOTE: fidget.nvim will soon be completely rewritten. In the meantime, tag legacy to avoid breaking changes.
				tag = "legacy",
				enabled = false,
				config = function()
					require("fidget").setup({
						text = {
							done = "",
						},
						window = {
							blend = 0, -- &winblend for the window
						},
					})
				end,
			},
		},
	},

	{ "WhoIsSethDaniel/lualine-lsp-progress.nvim" },

	-- LSP signature help
	{ "ray-x/lsp_signature.nvim", lazy = true },

	-- LSP code action menu with diff preview
	{
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu", -- lazy loaded, only activate plugin when CodeActionMenu initiated
	},

	-- RUST
	{ "simrat39/rust-tools.nvim", lazy = true },

	-- GOLANG
	-- use ({ "https://github.com/ray-x/go.nvim" })

	---------------------
	--    Debugging    --
	---------------------

	"rcarriga/nvim-dap-ui",

	---------------------
	--   TREESITTER    --
	---------------------

	"JoosepAlviste/nvim-ts-context-commentstring",
	"p00f/nvim-ts-rainbow",
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
	-- use "ThePrimeagen/refactoring.nvim"
	-- use "windwp/nvim-spectre"
	-- use { "NTBBloodbath/rest.nvim" }
	-- use { "junegunn/vim-easy-align" }
	-- use { "kevinhwang91/nvim-bqf", ft = "qf" }
	-- https://github.com/is0n/jaq-nvim
	-- https://github.com/utilyre/barbecue.nvim -- better winbar
}
