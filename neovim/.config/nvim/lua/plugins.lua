local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- INFO: ignore lua diagnostic showing warning in fn.glob, not necessary to supply the rest of the arguments
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

--Autocommand that reloads neovim whenever you save the plugins.lua file
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "plugins.lua",
	command = "source <afile> | PackerSync",
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
  -- snapshot = "aug-22",
  -- snapshot_path = fn.stdpath "config" .. "/snapshots",
  max_jobs = 50,
	display = {
		open_fn = function()
			return require("packer.util").float({
				border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
			})
		end,
    prompt_borer = "rounded"
	},
})

local is_wsl = (function()
	local output = vim.fn.systemlist("uname -r")
	return not not string.find(output[1] or "", "WSL")
end)()

-- if is_wsl then
--   vim.notify("Welcome to Subsytem Linux!")
-- end

-- Install your plugins here
return packer.startup(function(use)
	-- Load lua path
	local lua_path = function(name)
		return string.format("require'plugins.%s'", name)
	end

	---------------------
	-- Setup Utilities --
	---------------------

	-- Have packer manage itself
	use("wbthomason/packer.nvim")

	-- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/popup.nvim")

	-- Useful lua functions used by lots of plugins
	use("nvim-lua/plenary.nvim")

  -- UI Component Library for Neovim
  use("MunifTanjim/nui.nvim")

	-- Speeding up startup
	use({
		"lewis6991/impatient.nvim",
		config = function()
			require("impatient").enable_profile()
		end,
	})

	-- Dev Icons also required (for me)
	use({ "kyazdani42/nvim-web-devicons", config = lua_path("nvim-web-devicons") })

	-- Session Manager
	use({ "rmagatti/auto-session", config = lua_path("auto-session") })
	use({ "rmagatti/session-lens" })

	-- Easily comment stuff
	use({ "numToStr/Comment.nvim", config = lua_path("comment") })

	-- File Explorer
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			{
				-- only needed if you want to use the commands with "_with_window_picker" suffix
				"s1n7ax/nvim-window-picker",
				tag = "v1.*",
				config = function()
					require("window-picker").setup({
						autoselect_one = true,
						include_current = false,
						filter_rules = {
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal" },
							},
						},
						other_win_hl_color = "#e35e4f",
					})
				end,
			},
		},
		config = lua_path("nvim-neo-tree"),
	})

	-- Tabs
	use({
		"noib3/nvim-cokeline",
		config = lua_path("cokeline"),
	})

	-- Closing buffers
	use("moll/vim-bbye")

  -- Cycling buffers (i.e tab navigation for buffer)
  use({ "ghillb/cybu.nvim", config = lua_path("cybu") })

	-- Statusline
	use({ "nvim-lualine/lualine.nvim", config = lua_path("lualine") })

	-- Floating terminals
	use({ "akinsho/toggleterm.nvim", config = lua_path("toggleterm") })

	-- Project management
	use({ "ahmedkhalf/project.nvim", config = lua_path("project") })

	-- Smooth scroll
	use({ "karb94/neoscroll.nvim", disable = true, config = lua_path("neoscroll") })

	-- Remove mapping escape delay
	use({
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				mapping = { "jk", "kj" },
			})
		end,
	})

	-- Indentation Guides
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = lua_path("indent-blankline"),
	})

	-- Alpha Menu
	use({ "goolord/alpha-nvim", config = lua_path("alpha-nvim") })

	-- This is need to fix some plugins cursor problems
	use("antoinemadec/FixCursorHold.nvim")

	-- Which Key Binding
	use({ "folke/which-key.nvim", config = lua_path("which-key") })

	-- For jumping cursor in every word
	use("unblevable/quick-scope")

	-- Easy motion. Crazy fast jumping cursor
  -- ALT - https://github.com/ggandor/leap.nvim
	use({ "phaazon/hop.nvim", config = lua_path("hop") })

	-- Multiple Select Cursor
	use({ "mg979/vim-visual-multi", branch = "master" })

	-- nvim-surround
	use({ "kylechui/nvim-surround", config = lua_path("nvim-surround") })

	-- Tracking Code stats
	use("wakatime/vim-wakatime")

	-- Todo Comments
	use({ "folke/todo-comments.nvim", config = lua_path("todo-comments") })

	-- Notification
	use({ "rcarriga/nvim-notify", config = lua_path("nvim-notify") })

	-- Markdown Previewer
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- plugin to specify, or on the fly, mark and create persisting key strokes to go to the files you want.
	use("ThePrimeagen/harpoon")

  -- All the npm/yarn/pnpm commands I don't want to type
  -- use({ "vuki656/package-info.nvim", config = lua_path("package-info") })

	---------------------
	--  COLOR SCHEMES  --
	---------------------

	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	use("sainnhe/gruvbox-material")

	-- Color highlighter for Neovim
	use({ "norcalli/nvim-colorizer.lua", config = lua_path("nvim-colorizer") })

	---------------------
	-- AUTO COMPLETION --
	---------------------

	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for neovim's built-in language server client
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
  use({ "tzachar/cmp-tabnine", run = "./install.sh" })

	---------------------
	--    SNIPPETS     --
	---------------------

	use("L3MON4D3/LuaSnip") -- snippet engine, requires cmp_luasnip in order to work
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	---------------------
	--      LSP        --
	---------------------

	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
	use("folke/neodev.nvim") -- full signature help, docs and completion for the nvim lua API
	use("b0o/schemastore.nvim") -- providing access to the SchemaStore catalog.

  -- LSP partial implementation inlay-hints
  use({ "lvimuser/lsp-inlayhints.nvim", config = lua_path("lsp-inlayhints") })

	-- LSP signature help
	use("ray-x/lsp_signature.nvim")

	-- LSP document highlight
	use({"RRethy/vim-illuminate", config = lua_path("vim-illuminate") })

	-- LSP code action menu with diff preview
	use({
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu", -- lazy loaded, only activate plugin when CodeActionMenu initiated
	})

	-- LSP code action prompt
	use({ "kosayoda/nvim-lightbulb", config = lua_path("nvim-lightbulb") })

	-- Renamer
	use({ "filipdutescu/renamer.nvim", branch = "master", config = lua_path("renamer") })

	-- show current code context in winbar
	use({ "SmiteshP/nvim-navic", config = lua_path("nvim-navic") })

	-- Trouble A pretty diagnostic
	-- use("folke/trouble.nvim")

  -- LSP diagnostic lines
  use({ "https://git.sr.ht/~whynothugo/lsp_lines.nvim", config = lua_path("lsp_lines" )})

  -- RUST
  use({ "simrat39/rust-tools.nvim" })
  use ({ "Saecki/crates.nvim", config = lua_path("crates") })

  -- GOLANG
  use ({ "https://github.com/ray-x/go.nvim" })

	---------------------
	--    Debugging    --
	---------------------

  use ({ "mfussenegger/nvim-dap", config = lua_path("nvim-dap") })
  use "rcarriga/nvim-dap-ui"

	---------------------
	--    Telescope    --
	---------------------

	use({ "nvim-telescope/telescope.nvim", config = lua_path("telescope") })
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-ui-select.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	---------------------
	--   TREESITTER    --
	---------------------

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = lua_path("nvim-treesitter") })
	use({ "nvim-treesitter/nvim-treesitter-context" })
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  -- use({ "nvim-treesitter/playground" })
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use({ "p00f/nvim-ts-rainbow" })
	use({ "windwp/nvim-autopairs", config = lua_path("nvim-autopairs") })
	use({ "windwp/nvim-ts-autotag" })

	-- Treesitter text dimming
	use({
		"folke/twilight.nvim",
		cmd = { "Twilight" },
		setup = function()
			vim.keymap.set("n", "<C-z>", "<Cmd>Twilight<CR>", { desc = "dim inactive surroundings" })
		end,
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
	})

	---------------------
	--      GIT        --
	---------------------

	use({ "lewis6991/gitsigns.nvim", config = lua_path("gitsigns") })
  use ({
    "akinsho/git-conflict.nvim",
    tag = "*",
    config = function()
      require('git-conflict').setup()
    end
  })

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
	-- use { "sunjon/stylish.nvim" } -- stylish UI Components for Neovim
  -- https://github.com/is0n/jaq-nvim
  -- https://github.com/B4mbus/nvim-headband -- soon. a simple and opinionated winbar
  -- use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'} -- code folding

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
