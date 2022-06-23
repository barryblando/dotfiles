local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		-- Basic Formatting needs
		formatting.prettier.with({
			filetypes = {
				"css",
				"scss",
				"less",
				"html",
				"json",
				"jsonc",
				"yaml",
				"markdown",
				"graphql",
				"handlebars",
			},
			condition = function(utils)
				return utils.root_has_file({
					".prettierrc.json",
					".prettierignore",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.json5",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.config.js",
					".prettierrc.config.cjs",
				})
			end,
			prefer_local = "node_modules/.bin", -- find local prettier, fall back to global prettier if it can't find one locally
		}),

		-- Typescript, Javascript, React, Vue
		formatting.eslint.with({}),
		diagnostics.eslint.with({}),

		-- Lua
		formatting.stylua,

		-- Docker (brew install hadolint, scoop install hadolint)
		diagnostics.hadolint,

		-- Protocol Buffers
		formatting.buf,
		diagnostics.buf,

		-- Ansible
		diagnostics.ansiblelint,

		-- null_ls.builtins.code_actions.refactoring,
	},
})
