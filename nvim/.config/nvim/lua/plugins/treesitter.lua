local M = {}

M.init = function()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			-- Enable treesitter highlighting and disable regex syntax
			pcall(vim.treesitter.start)
			-- Enable treesitter-based indentation
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})

	local ensureInstalled = {
		"bash",
		"dockerfile",
		"lua",
		"rust",
		"go",
		"javascript",
		"typescript",
		"tsx",
		"graphql",
		"prisma",
		"http",
		"json",
		"make",
		"proto",
		"markdown",
		"html",
		"css",
		"scss",
		"yaml",
		"toml",
		"query",
		"regex",
		"kdl",
		"powershell",
		"fish",
	}

	local alreadyInstalled = require("nvim-treesitter.config").get_installed()
	local parsersToInstall = vim.iter(ensureInstalled)
		:filter(function(parser)
			return not vim.tbl_contains(alreadyInstalled, parser)
		end)
		:totable()
	require("nvim-treesitter").install(parsersToInstall)
end

M.config = function()
	local status_ok, configs = pcall(require, "nvim-treesitter")

	if not status_ok then
		return
	end

	configs.setup({
		sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
		ignore_install = { "" }, -- List of parsers to ignore installing
		autopairs = {
			enable = true,
		},
		autotag = {
			enable = true,
			filetypes = {
				"css",
				"html",
				"jsx",
				"javascript",
				"javascriptreact",
				"markdown",
				"svelte",
				"typescript",
				"typescriptreact",
				"vue",
				"xhtml",
				"xml",
			},
			skip_tags = {
				"area",
				"base",
				"br",
				"col",
				"command",
				"embed",
				"hr",
				"img",
				"slot",
				"input",
				"keygen",
				"link",
				"meta",
				"param",
				"source",
				"track",
				"wbr",
				"menuitem",
			},
		},
		-- playground = {
		--   enable = true,
		-- },
		textobjects = {
			select = {
				enable = true,
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["at"] = "@class.outer",
					["it"] = "@class.inner",
					["ac"] = "@call.outer",
					["ic"] = "@call.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
					["ai"] = "@conditional.outer",
					["ii"] = "@conditional.inner",
					["a/"] = "@comment.outer",
					["i/"] = "@comment.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["as"] = "@statement.outer",
					["is"] = "@scopename.inner",
					["aA"] = "@attribute.outer",
					["iA"] = "@attribute.inner",
					["aF"] = "@frame.outer",
					["iF"] = "@frame.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["[."] = "@parameter.inner",
				},
				swap_previous = {
					["[,"] = "@parameter.inner",
				},
			},
		},
	})
end

return M
