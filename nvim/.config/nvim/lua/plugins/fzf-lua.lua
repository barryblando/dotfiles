local M = {}

M.config = function()
	-- Default fallback settings
	local default_border = "border-bottom"
	local default_pager = "delta --line-numbers"

	-- Special overrides per section (only if you want to override)
	local overrides = {
		commits = { pager = "delta --line-numbers", border = "border-bottom" },
		bcommits = { pager = "delta --line-numbers", border = "border-bottom" },
		branches = { pager = "less", border = "border-top" },
		stash = { pager = "less", border = "border-top" },
		status = { pager = "bat --plain", border = "border-bottom" },
		tag = { pager = "bat --plain", border = "border-bottom" },
		blame = { pager = "bat --plain", border = "border-bottom" },
	}

	-- All git sections
	local sections = { "commits", "bcommits", "branches", "stash", "status", "tag", "blame" }

	-- Build dynamically
	local git_settings = {}

	for _, section in ipairs(sections) do
		local o = overrides[section] or {}
		git_settings[section] = {
			winopts = { preview = { border = o.border or default_border } },
			preview_pager = o.pager or default_pager,
		}
	end

	require("fzf-lua").setup({
		file_icon_padding = " ",
		winopts = {
			border = "border-sharp",
			fullscreen = false,
			preview = {
				border = "border-sharp",
				layout = "vertical",
				vertical = "up:65%",
				scrollbar = false,
				wrap = "wrap",
			},
		},
		files = {
			-- previewer = "bat", -- or 'builtin'
			git_icons = true,
			file_icons = true,
		},
		grep = {
			-- rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!node_modules/*'",
			rg_opts = table.concat({
				"--hidden", -- include hidden files
				"--no-ignore-vcs", -- search in .gitignored files too
				"--glob=!node_modules/*", -- ignore node_modules
				"--glob=!vendor/*", -- ignore vendor/ if you do Go/PHP
				"--glob=!.git/*", -- ignore .git folder (speed up)
				"--column", -- show column number
				"--line-number", -- show line number
				"--no-heading", -- no file heading, easier fzf parsing
				"--color=always", -- force color output (important)
				"--smart-case", -- smart case (case insensitive if all lowercase)
				"--trim", -- trim whitespace
				"--max-columns=4096", -- avoid slow parsing with huge files
				"--follow", -- follow symlinks
				"--ignore-case", -- optionally force ignore-case
			}, " "),
		},
		git = git_settings,
		lsp = { code_actions = { previewer = "codeaction_native" } },
	})
end

return M
