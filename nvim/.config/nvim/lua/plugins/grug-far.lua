local M = {}
local utils = require("core.utils")

-- Local function to get placeholders for each language
local language_placeholders = {
	rs = {
		enabled = true,
		search = "fn\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
		replacement = "fn ${1}_foo${2} ->",
		replacement_lua = 'return vars.A == "blah" and "foo(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
		filesFilter = "*.{rs,toml}\n**/src/**/*.{rs,toml}",
		rg_flags = "--type rs --line-number --color=always --smart-case",
		astgrep_flags = "--debug-query=ast --strictness=high",
		paths = "./src/main.rs\n../libs/utils.rs",
	},
	ts = {
		enabled = true,
		search = "function\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
		replacement = "function ${1}_foo${2} :",
		replacement_lua = 'return vars.A == "foo" and "function(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
		filesFilter = "*.{ts,tsx}\n**/src/**/*.{ts,tsx}",
		rg_flags = "--type ts --line-number --color=always --smart-case",
		astgrep_flags = "--debug-query=ast --strictness=medium",
		paths = "./src/index.ts\n../libs/utils.ts",
	},
	go = {
		enabled = true,
		search = "func\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
		replacement = "func ${1}_foo(${2})",
		replacement_lua = 'return vars.A == "bar" and "func(" .. table.concat(vars.ARGS, ", ") .. ")" or match',
		filesFilter = "*.go\n**/src/**/*.go",
		rg_flags = "--type go --line-number --color=always --smart-case",
		astgrep_flags = "--debug-query=ast --strictness=low",
		paths = "./main.go\n../libs/utils.go",
	},
	py = {
		enabled = true,
		search = "def\\s+([a-zA-Z_][a-zA0-9_]*)\\s*\\(",
		replacement = "def ${1}_foo${2} :",
		replacement_lua = 'return vars.A == "foo" and "def " .. vars.ARGS[1] .. "()" or match',
		filesFilter = "*.py\n**/src/**/*.py",
		rg_flags = "--type py --line-number --color=always --smart-case",
		astgrep_flags = "--debug-query=ast --strictness=medium",
		paths = "./main.py\n../libs/utils.py",
	},
	ex = {
		enabled = true,
		search = "def\\s+([a-zA-Z_][a-zA-Z0-9_]*)\\s*\\(",
		replacement = "def ${1}_foo${2} do",
		replacement_lua = 'return vars.A == "bar" and "def " .. vars.ARGS[1] .. " do" or match',
		filesFilter = "*.{ex,exs}\n**/src/**/*.{ex,exs}",
		rg_flags = "--line-number --color=always --smart-case",
		astgrep_flags = "--debug-query=ast --strictness=low",
		paths = "./src/main.ex\n../libs/utils.ex",
	},
	default = {
		enabled = true,
		search = "e.g. foo   foo([a-z0-9]*)   fun\\(",
		replacement = "e.g. bar   ${1}_foo   $$MY_ENV_VAR ",
		replacement_lua = 'e.g. if vim.startsWith(match, "use") \\n then return "employ" .. match \\n else return match end',
		filesFilter = "e.g. *.lua   *.{css,js}   **/docs/*.md   (specify one per line)",
		rg_flags = "--line-number --color=always --smart-case",
		astgrep_flags = "--debug-query=ast --strictness=medium",
		paths = "e.g. /foo/bar   ../   ./hello\\ world/   ./src/foo.lua   ~/.config",
	},
}

local function update_flags_by_engine(placeholders, engine)
	local updated = {}

	for lang, entry in pairs(placeholders) do
		-- Create a shallow copy to avoid mutating the original
		local copy = vim.tbl_deep_extend("force", {}, entry)

		-- Determine engine-specific flag key
		local engine_flags_key = engine == "rg" and "rg_flags" or engine == "ast-grep" and "astgrep_flags" or nil

		if engine_flags_key then
			copy.flags = copy[engine_flags_key] or ""
		else
			copy.flags = ""
		end

		-- Remove engine-specific flags
		copy.rg_flags = nil
		copy.astgrep_flags = nil

		updated[lang] = copy
	end

	return updated
end

local function get_placeholder(engine)
	return update_flags_by_engine(language_placeholders, engine)
end

local engines = {
	ripgrep = {
		path = "rg",
		extraArgs = "",
		placeholders = vim.fn.expand("%:e") ~= nil and get_placeholder("rg")[vim.fn.expand("%:e")]
			or get_placeholder("rg")["default"],
	},
	astgrep = {
		path = "ast-grep",
		extraArgs = "",
		placeholders = vim.fn.expand("%:e") ~= nil and get_placeholder("ast-grep")[vim.fn.expand("%:e")]
			or get_placeholder("ast-grep")["default"],
	},
}

M.default_engine = "ripgrep" -- or "ast-grep"

local function grug_far(engine)
	local raw, escaped = utils.get_visual_selection()

	local search = ((engine == "sg" or engine == "astgrep") and raw or escaped) or ""

	local placeholder = vim.fn.expand("%:e") ~= nil and get_placeholder(engine)[vim.fn.expand("%:e")] or ""

	require("grug-far").open({
		engines = engines,
		engine = engine,
		prefills = {
			search = search,
			paths = vim.loop.cwd(),
			filesFilter = placeholder.filesFilter,
			flags = placeholder.flags,
		},
	})
end

M.keys = function()
	return {
		-- Normal mode, default rg
		{
			"<leader>Fr",
			function()
				grug_far("ripgrep")
			end,
			desc = "GrugFar | Find And Replace (rg)",
		},
		-- Normal mode, ast-grep engine
		{
			"<leader>Fa",
			function()
				grug_far("astgrep")
			end,
			desc = "GrugFar | AST-Grep Search",
		},
		-- Visual selection with default engine
		{
			"<leader>Ff",
			function()
				grug_far("ripgrep")
			end,
			desc = "GrugFar | Visual Search",
			mode = "v",
		},
		-- Visual mode, ast-grep engine
		{
			"<leader>Fa",
			function()
				grug_far("astgrep")
			end,
			desc = "GrugFar | AST-Grep Search (Visual)",
			mode = "v",
		},
	}
end

M.config = function()
	local icons = require("core.icons")

	require("grug-far").setup({
		-- debounce milliseconds for issuing search while user is typing
		debounceMs = 500,
		enabledEngines = { "ripgrep", "astgrep", "astgrep-rules" },

		engines = engines,
		engine = M.default_engine,
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
