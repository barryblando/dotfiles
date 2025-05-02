local M = {}
local utils = require("core.utils")

-- Local function to get placeholders for each language
local function get_placeholders(language)
	if language == "rs" then
		return {
			enabled = true,
			search = "fn\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
			replacement = "fn ${1}_foo${2} ->",
			replacement_lua = 'return vars.A == "blah" and "foo(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
			filesFilter = "*.rs   **/src/**/*.rs",
			flags = "--help (-h) --debug-query=ast --rewrite= --strictness=high",
			paths = "./src/main.rs   ../libs/utils.rs",
		}
	elseif language == "ts" then
		return {
			enabled = true,
			search = "function\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
			replacement = "function ${1}_foo${2} :",
			replacement_lua = 'return vars.A == "foo" and "function(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
			filesFilter = "*.ts   **/src/**/*.ts",
			flags = "--help (-h) --debug-query=ast --rewrite= --strictness=medium",
			paths = "./src/index.ts   ../libs/utils.ts",
		}
	elseif language == "go" then
		return {
			enabled = true,
			search = "func\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
			replacement = "func ${1}_foo(${2})",
			replacement_lua = 'return vars.A == "bar" and "func(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
			filesFilter = "*.go   **/src/**/*.go",
			flags = "--help (-h) --debug-query=ast --rewrite= --strictness=low",
			paths = "./main.go   ../libs/utils.go",
		}
	elseif language == "py" then
		return {
			enabled = true,
			search = "def\\s+([a-zA-Z_][a-zA0-9_]*)\\s*\\(",
			replacement = "def ${1}_foo${2} :",
			replacement_lua = 'return vars.A == "foo" and "def " .. vars.ARGS[1] .. "()" or match',
			filesFilter = "*.py   **/src/**/*.py",
			flags = "--help (-h) --debug-query=ast --rewrite= --strictness=medium",
			paths = "./main.py   ../libs/utils.py",
		}
	elseif language == "ex" then
		return {
			enabled = true,
			search = "def\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
			replacement = "def ${1}_foo${2} do",
			replacement_lua = 'return vars.A == "bar" and "def " .. vars.ARGS[1] .. " do" or match',
			filesFilter = "*.ex   **/src/**/*.ex",
			flags = "--help (-h) --debug-query=ast --rewrite= --strictness=low",
			paths = "./src/main.ex   ../libs/utils.ex",
		}
	else
		return {
			enabled = true,
			search = "e.g. $A && $A()   foo.bar($$$ARGS)   $_FUNC($_FUNC)",
			replacement = "e.g. $A?.()   blah($$$ARGS)",
			replacement_lua = 'e.g. return vars.A == "blah" and "foo(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
			filesFilter = "e.g. *.lua   *.{css,js}   **/docs/*.md   (specify one per line, filters via ripgrep)",
			flags = "e.g. --help (-h) --debug-query=ast --rewrite= (empty replace) --strictness=<STRICTNESS>",
			paths = "e.g. /foo/bar   ../   ./hello\\ world/   ./src/foo.lua   ~/.config",
		}
	end
end

local function grug_far_visual()
	local search = utils.get_visual_selection()

	local lang_filters = {
		lua = "*.lua",
		rust = "*.{rs,toml}",
		typescript = "*.{ts,tsx}",
		go = "*.go",
		python = "*.py",
		elixir = "*.{ex,exs}",
	}

	local function get_file_filter()
		local ft = vim.bo.filetype
		return lang_filters[ft] or "*"
	end

	require("grug-far").open({
		prefills = {
			search = vim.fn.trim(search),
			paths = vim.loop.cwd(),
			filesFilter = get_file_filter(),
		},
	})
end

M.keys = function()
	return {
		{
			"<leader>gf",
			function()
				grug_far_visual()
			end,
			desc = "Visual Search",
			mode = "v",
		},
		{
			"<leader>R",
			function()
				require("grug-far").open({ prefills = { paths = vim.loop.cwd() } })
			end,
			desc = "GrugFar | Find And Replace",
		},
	}
end

M.config = function()
	local icons = require("core.icons")

	require("grug-far").setup({
		-- debounce milliseconds for issuing search while user is typing
		debounceMs = 500,
		enabledEngines = { "ripgrep", "astgrep", "astgrep-rules" },

		-- engines configuration
		engines = {
			ripgrep = {
				path = "rg",
				extraArgs = "",
				placeholders = get_placeholders(vim.fn.expand("%:e")),
			},
			astgrep = {
				path = "ast-grep",
				extraArgs = "",
				placeholders = get_placeholders(vim.fn.expand("%:e")),
			},

			["astgrep-rules"] = {
				path = "ast-grep",
				extraArgs = "",
				placeholders = get_placeholders(vim.fn.expand("%:e")),
			},
		},

		engine = "ripgrep",
		enabledReplacementInterpreters = { "default", "lua", "vimscript" },
		windowCreationCommand = "vsplit",
		disableBufferLineNumbers = true,
		helpLine = { enabled = true },

		keymaps = {
			replace = { n = "<localleader>r" },
			qflist = { n = "<localleader>q" },
			syncLocations = { n = "<localleader>s" },
			close = { n = "<localleader>c" },
			help = { n = "g?" },
			refresh = { n = "<localleader>f" },
		},

		-- file path conceal
		filePathConceal = function(params)
			local len = #params.file_path
			local window_width = params.window_width - 8
			if len < params.window_width then
				return
			end

			local first_part_len = math.floor(window_width / 3)
			local delta = len - window_width

			return first_part_len, first_part_len + delta
		end,

		filePathConcealChar = "…",
		spinnerStates = {
			"󱑋 ",
			"󱑌 ",
			"󱑍 ",
			"󱑎 ",
			"󱑏 ",
		},

		-- report duration for replace/sync operations
		reportDuration = true,

		icons = {
			enabled = true,
			fileIconsProvider = "first_available",
			actionEntryBullet = " ",
			searchInput = " ",
			replaceInput = " ",
			resultsStatusReady = "󱩾 ",
			resultsStatusError = " ",
		},

		-- Options related to the target window for goto or open actions
		openTargetWindow = {
			-- Exclude filetypes or custom filter functions for candidate windows
			exclude = { "help", "NvimTree" }, -- Exclude help and NvimTree windows from being considered for opening
			-- Preferred location for target window relative to the grug-far window
			preferredLocation = "right", -- Opens the target window to the right if possible
			-- Use a temporary scratch buffer to prevent resource consumption by language servers
			useScratchBuffer = true,
		},

		helpWindow = {
			border = icons.ui.Border_Single_Line,
			style = "minimal",
		},

		historyWindow = {
			border = icons.ui.Border_Single_Line,
			style = "normal",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},

		previewWindow = {
			border = icons.ui.Border_Single_Line,
			style = "minimal",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	})
end

return M
